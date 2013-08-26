class mysql::server::service {
  service {
    'mysql':
      ensure => running,
      enable => true;
  }
}
