class puppet::agent::service {
  service {
    'puppet':
      ensure => running,
      enable => true;
  }
}
