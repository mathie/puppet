class nginx::php::install {
  package {
    [ 'php5-cli', 'php5-cgi', 'php5-fpm' ]:
      ensure => installed;
  }
}
