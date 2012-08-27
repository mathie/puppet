class nginx::install {
  package {
    [ 'nginx-full', 'nginx' ]:
      ensure => installed;
  }
}
