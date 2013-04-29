class puppetdb::client::install {
  include puppet::repo

  package {
    'puppetdb-terminus':
      ensure => present;
  }

  anchor { 'puppetdb::client::install::begin': } ->
    Class['puppet::repo'] ->
    Package['puppetdb-terminus'] ->
    anchor { 'puppetdb::client::install::end': }
}
