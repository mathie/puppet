class nagios::nrpe_check::disk_space(
  $warning  = '20%',
  $critical = '10%'
) {
  nagios::nrpe_check {
    'disk':
      service_description => 'Disk space',
      groups              => [ 'host' ],
      arguments           => '-e',
      warning             => $warning,
      critical            => $critical;
  }
}
