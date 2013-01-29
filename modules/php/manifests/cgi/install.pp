class php::cgi::install {
  package {
    'php5-cgi':
      ensure => installed;
  }
}
