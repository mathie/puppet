class ruby::ruby18::install {
  include ruby::install

  package {
    [ 'ruby1.8', 'ruby1.8-dev', 'rubygems' ]:
      ensure => present;
  }
}
