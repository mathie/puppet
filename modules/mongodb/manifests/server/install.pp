class mongodb::server::install {
  package {
    'mongodb':
      ensure => present;
  }
}
