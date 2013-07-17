class apt::cache::server::service {
  service {
    'apt-cacher-ng':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'apt-cacher-ng':
      port => '3142';
  }
}
