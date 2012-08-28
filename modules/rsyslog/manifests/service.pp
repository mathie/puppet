class rsyslog::service {
  service {
    'rsyslog':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'rsyslog-ssl':
      port => '10514';
  }
}
