class nagios::nrpe_check::processes(
  $warning  = 250,
  $critical = 400
) {
  nagios::nrpe_check {
    'procs':
      service_description => 'Total processes',
      groups              => [ 'host' ],
      warning             => $warning,
      critical            => $critical;
  }
}
