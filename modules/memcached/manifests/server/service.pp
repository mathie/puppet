class memcached::server::service {
  service {
    'memcached':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'memcached':
      port => '11211';
  }
}
