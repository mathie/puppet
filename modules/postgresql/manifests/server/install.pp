class postgresql::server::install {
  package {
    'postgresql':
      ensure => present;
  }
}
