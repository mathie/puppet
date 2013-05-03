class nagios::agent::install {
  package {
    'nagios-nrpe-server':
      ensure => installed;
  }
}
