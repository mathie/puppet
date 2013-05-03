define nagios::nrpe_check(
  $service_description,
  $warning       = undef,
  $critical      = undef,
  $arguments     = undef,
  $check_command = undef,
  $percona       = false,
  $groups        = undef,
  $sudo          = false,
  $ensure        = present
) {

  include nagios::agent

  $check_name = $name

  $real_check_command = $check_command ? {
    undef => $percona ? {
      true    => "pmp-check-${check_name}",
      default => "check_${check_name}",
    },
    default => $check_command,
  }

  $check_command_path = $percona ? {
    true    => '/usr/lib64/nagios/plugins',
    default => '/usr/lib/nagios/plugins',
  }

  if $sudo {
    sudo::user {
      $check_name:
        user        => 'nagios',
        commands    => "${check_command_path}/${real_check_command}",
        no_password => true,
        as          => 'root';
    }
  }

  @@nagios_service {
    "${::hostname}_${check_name}":
      ensure              => $ensure,
      host_name           => $::fqdn,
      service_description => $service_description,
      servicegroups       => $groups,
      check_command       => "check_nrpe_1arg!${check_name}";
  }

  $warning_string = $warning ? {
    undef   => undef,
    default => inline_template('<%= @warning.respond_to?(:join) ? @warning.join(",") : @warning %>'),
  }

  $critical_string = $critical ? {
    undef   => undef,
    default => inline_template('<%= @critical.respond_to?(:join) ? @critical.join(",") : @critical %>'),
  }

  concat::fragment {
    "nagios-nrpe-check-${check_name}":
      file => 'nagios-nrpe-config',
      content => template('nagios/nrpe-check.conf.erb');
  }

  anchor { "nagios::nrpe_check::${check_name}::begin": } ->
    Class['nagios::agent'] ->
    anchor { "nagios::nrpe_check::${check_name}::end": }
}
