class mysql::server::service {
  service {
    'mysql':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'mysql':
      port => '3306';
  }
}
