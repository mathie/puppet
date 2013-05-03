class apt::cache::server::install {
  package {
    'apt-cacher-ng':
      ensure => present;
  }
}
