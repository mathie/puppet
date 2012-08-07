class redis::server::service {
  service {
    'redis-server':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true;
  }
}
