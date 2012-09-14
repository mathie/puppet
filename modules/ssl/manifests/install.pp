class ssl::install {
  package {
    'ca-certificates':
      ensure => present;
  }
}
