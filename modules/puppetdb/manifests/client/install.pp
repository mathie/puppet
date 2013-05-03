class puppetdb::client::install {
  include puppet::repo

  package {
    'puppetdb-terminus':
      ensure => present;
  }
}
