class mongodb::server::service {
  service {
    'mongodb':
      ensure => running,
      enable => true;
  }
}
