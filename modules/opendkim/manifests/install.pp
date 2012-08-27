class opendkim::install {
  package {
    'opendkim':
      ensure => present;
  }
}
