class graphite::service {
  service {
    'carbon-cache':
      ensure => running,
      enable => true;

    'graphite-web':
      ensure => running,
      enable => true;
  }
}
