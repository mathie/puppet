class ntp::server::install {
  package {
    'ntp':
      ensure => present;
  }
}
