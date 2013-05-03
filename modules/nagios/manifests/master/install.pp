class nagios::master::install {
  package {
    'nagios3':
      ensure  => installed,
      require => Class['nginx::php'];

    'nagios-nrpe-plugin':
      ensure => installed;
  }
}
