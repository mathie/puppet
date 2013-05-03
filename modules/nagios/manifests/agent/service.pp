class nagios::agent::service {
  service {
    'nagios-nrpe-server':
      ensure => running,
      enable => true;
  }
}
