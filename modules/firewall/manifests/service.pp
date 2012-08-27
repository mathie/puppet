class firewall::service {
  service {
    'ufw':
      ensure => running,
      enable => true;
  }
}
