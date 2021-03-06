class ruby::ruby18::install {
  include ruby::repo
  include ruby::install

  package {
    [ 'ruby1.8', 'rubygems' ]:
      ensure => present;
  }

  anchor { 'ruby::ruby18::install::begin': } ->
    Class['ruby::install'] ->
    anchor { 'ruby::ruby18::install::end': }
}
