class nginx::fcgi::service {
  service {
    'fcgiwrap':
      ensure => running,
      enable => true;
  }
}
