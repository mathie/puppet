class puppet::dashboard::service {
  service {
    'puppet-dashboard':
      ensure => running,
      enable => true;

    'puppet-dashboard-workers':
      ensure => running,
      enable => true;
  }
}
