class postgresql::server::service {
  service {
    'postgresql':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'postgresql':
      port => 5432;
  }
}
