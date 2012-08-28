class puppet::master::install {
  include ruby::ruby18

  package {
    'puppetmaster':
      ensure => installed;

    'puppetdb-terminus':
      ensure => present;
  }

  Class['puppet::repo'] -> Exec['apt-get-update'] -> Class['puppet::master::install']
}
