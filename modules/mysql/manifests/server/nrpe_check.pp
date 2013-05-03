define mysql::server::nrpe_check(
  $description,
  $command    = $name,
  $subcommand = undef,
  $sudo       = false,
  $arguments  = undef,
  $warning    = undef,
  $critical   = undef
) {
  # The documentation claims it really wants a space between the -p and the
  # password...
  $root_password_flag = $mysql::server::root_password ? {
    undef   => '',
    default => " -p ${mysql::server::root_password}",
  }
  $authentication_arguments = "-l root${root_password_flag}"

  $full_arguments = $subcommand ? {
    undef   => $arguments ? {
      undef   => $authentication_arguments,
      default => "${authentication_arguments} ${arguments}",
    },
    default   => "${authentication_arguments} -C ${subcommand}",
  }

  $check_name = $subcommand ? {
    undef   => "mysql-${command}",
    default => "mysql-${command}-${subcommand}",
  }

  nagios::nrpe_check {
    $check_name:
      service_description => $description,
      groups              => [ 'mysql' ],
      check_command       => "pmp-check-mysql-${command}",
      sudo                => $sudo,
      percona             => true,
      arguments           => $full_arguments,
      warning             => $warning,
      critical            => $critical;
  }
}
