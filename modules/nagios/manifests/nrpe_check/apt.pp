class nagios::nrpe_check::apt {
  nagios::nrpe_check {
    'apt':
      service_description => 'Check for package updates',
      groups              => [ 'host' ];
  }
}
