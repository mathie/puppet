class nginx::fcgi::install {
  package {
    'fcgiwrap':
      ensure => installed;
  }
}
