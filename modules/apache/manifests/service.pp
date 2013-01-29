class apache::service {
  service {
    'apache2':
      ensure => running,
      enable => true;
  }
}
