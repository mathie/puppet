class ruby::ruby19::install {
  include ruby::repo
  include ruby::install

  package {
    [ 'ruby1.9.1' ]:
      ensure => present;
  }

  anchor { 'ruby::ruby19::install::begin': } ->
    Class['ruby::install'] ->
    anchor { 'ruby::ruby19::install::end': }
}
