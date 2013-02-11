class ssh::server::service {
  service {
    'ssh':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'ssh':
      port => $ssh::server::real_port;
  }
}
