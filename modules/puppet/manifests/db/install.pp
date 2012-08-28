class puppet::db::install {
  package { 'puppetdb':
    ensure => present,
  }
}
