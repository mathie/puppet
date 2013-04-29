class puppetdb::client::install {
  include puppet::repo

  package {
    'puppetdb-terminus':
      ensure => present;
  }

  Class['puppet::repo'] -> Package['puppetdb-terminus']
}
