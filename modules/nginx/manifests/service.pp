class nginx::service {
  service {
    'nginx':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'http':
      port => 80;

    'https':
      port => 443;
  }
}
