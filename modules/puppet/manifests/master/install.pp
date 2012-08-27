class puppet::master::install {
  include puppet::db::params
  include ruby::ruby18

  package {
    'puppetmaster':
      ensure => installed;

    'puppetdb-terminus':
      ensure => $puppet::db::params::puppetdb_version;
  }

  Class['puppet::repo'] -> Exec['apt-get-update'] -> Class['puppet::master::install']
}
