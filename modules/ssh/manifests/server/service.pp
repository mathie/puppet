class ssh::server::service {
  service {
    'ssh':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'ssh':
      port => '22';
  }
}
