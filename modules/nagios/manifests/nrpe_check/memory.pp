class nagios::nrpe_check::memory(
  $warning  = 90,
  $critical = 95
) {
  nagios::nrpe_check {
    'unix-memory':
      service_description => 'Free memory',
      groups              => [ 'host' ],
      percona             => true,
      warning             => $warning,
      critical            => $critical;
  }
}
