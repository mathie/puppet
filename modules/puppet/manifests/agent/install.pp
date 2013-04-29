class puppet::agent::install {
  include puppet::repo
  include ruby::ruby18

  package { 'puppet':
    ensure => present,
  }

  Class['puppet::repo'] -> Class['puppet::agent::install']
}
