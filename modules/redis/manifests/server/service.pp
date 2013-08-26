class redis::server::service {
  service {
    'redis-server':
      ensure => running,
      enable => true;
  }

  @firewall::allow {
    'redis':
      port => 6379;
  }
}
