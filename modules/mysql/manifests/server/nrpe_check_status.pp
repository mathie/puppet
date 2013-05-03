define mysql::server::nrpe_check_status(
  $description,
  $arguments,
  $warning,
  $critical
) {
  mysql::server::nrpe_check {
    "status-${name}":
      description => $description,
      command     => 'status',
      arguments   => $arguments,
      warning     => $warning,
      critical    => $critical;
  }
}
