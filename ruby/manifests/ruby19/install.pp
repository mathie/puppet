class ruby::ruby19::install {
  include ruby::install

  package {
    [ 'ruby1.9.1', 'ruby1.9.1-dev' ]:
      ensure => present;
  }
}
