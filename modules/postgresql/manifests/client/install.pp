class postgresql::client::install {
  package {
    'postgresql-client':
      ensure => present;
  }
}
