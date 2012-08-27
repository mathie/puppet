class puppet::db::install {
  package { 'puppetdb':
    ensure => $puppet::db::params::puppetdb_version,
  }
}
