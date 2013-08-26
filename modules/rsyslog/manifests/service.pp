class rsyslog::service {
  service {
    'rsyslog':
      ensure => running,
      enable => true;
  }
}
