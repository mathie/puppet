class memcached::server::install {
  package {
    'memcached':
      ensure => present;
  }
}
