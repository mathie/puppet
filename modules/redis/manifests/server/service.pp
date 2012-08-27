class redis::server::service {
  service {
    'redis-server':
      ensure => running,
      enable => true;
  }
}
