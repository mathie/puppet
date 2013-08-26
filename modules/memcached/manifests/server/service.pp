class memcached::server::service {
  service {
    'memcached':
      ensure => running,
      enable => true;
  }
}
