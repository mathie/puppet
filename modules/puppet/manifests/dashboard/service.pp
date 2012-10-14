class puppet::dashboard::service {
  service {
    'puppet-dashboard':
      ensure => running,
      enable => true;

    'puppet-dashboard-workers':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'puppet-dashboard-web':
      port => 8084;
  }
}
