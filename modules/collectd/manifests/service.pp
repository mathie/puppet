class collectd::service {
  service {
    'collectd':
      ensure => running,
      enable => true;
  }
}
