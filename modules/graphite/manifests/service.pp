class graphite::service {
  service {
    'carbon-cache':
      ensure => running,
      enable => true;
  }
}
