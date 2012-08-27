class firewall::install {
  package {
    'ufw':
      ensure => present;
  }
}
