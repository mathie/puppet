class redis::server::install {
  package {
    'redis-server':
      ensure => present;
  }
}
