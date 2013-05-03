class nagios::nrpe_check::load(
  $warning  = [ 5.0, 4.0, 3.0 ],
  $critical = [ 10.0, 6.0, 4.0 ]
) {
  nagios::nrpe_check {
    'load':
      service_description => 'Current load',
      groups              => [ 'host' ],
      warning             => $warning,
      critical            => $critical;
  }
}
