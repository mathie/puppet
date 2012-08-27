class ruby::install {
  package {
    [ 'ruby', 'ruby-switch' ]:
      ensure => present;
  }
}
