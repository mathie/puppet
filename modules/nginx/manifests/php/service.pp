class nginx::php::service {
  service {
    'php5-fpm':
      ensure => running,
      enable => true;
  }
}
