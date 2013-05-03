define nagios::check(
  $service_description,
  $warning       = undef,
  $critical      = undef,
  $arguments     = undef,
  $check_command = "check_${name}",
  $groups        = undef,
  $ensure        = present
) {

  $full_check_command = inline_template('<%= [ @check_command, @warning, @critical, @arguments ].flatten.compact.join("!") %>')

  @@nagios_service {
    "${::hostname}_${name}":
      ensure              => $ensure,
      host_name           => $::fqdn,
      service_description => $service_description,
      servicegroups       => $groups,
      check_command       => "${full_check_command}";
  }
}
