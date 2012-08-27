class ntp::server::service {
  service {
    'ntp':
      ensure => running,
      enable => true;
  }
}
