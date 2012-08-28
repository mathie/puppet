class postgresql::server::service {
  service {
    'postgresql':
      ensure => running,
      enable => true;
  }
}
