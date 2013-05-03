class puppetdb::server::install {
  include puppet::repo

  package {
    'puppetdb':
      ensure => present;
  }
}
