class nagios::master::service {
  service {
    'nagios3':
      ensure => running,
      enable => true;
  }
}
