class nagios::nrpe_check::users(
  $warning  = 20,
  $critical = 50
) {
  nagios::nrpe_check {
    'current_users':
      service_description => 'Current users',
      groups              => [ 'host' ],
      check_command       => 'check_users',
      warning             => $warning,
      critical            => $critical;
  }
}
