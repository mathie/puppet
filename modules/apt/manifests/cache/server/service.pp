class apt::cache::server::service {
  service {
    'apt-cacher-ng':
      ensure => running,
      enable => true;
  }
}
