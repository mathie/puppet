define mysql::server::nrpe_check_innodb(
  $description,
  $command  = undef,
  $warning  = undef,
  $critical = undef
) {

  $real_command = $command ? {
    undef   => regsubst($name, '-', '_', 'G'),
    default => $command,
  }

  mysql::server::nrpe_check {
    "innodb-${name}":
      description => $description,
      command     => 'innodb',
      subcommand  => $real_command,
      warning     => $warning,
      critical    => $critical;
  }
}
