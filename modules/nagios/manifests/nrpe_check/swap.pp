class nagios::nrpe_check::swap(
  $warning = '50%',
  $critical = '20%'
) {
  nagios::nrpe_check {
    'swap':
      service_description => 'Swap space',
      groups              => [ 'host' ],
      warning             => $warning,
      critical            => $critical;
  }
}
