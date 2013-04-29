class puppetdb::server::install {
  include puppet::repo

  package {
    'puppetdb':
      ensure => present;
  }

  anchor { 'puppetdb::server::install::begin': } ->
    Class['puppet::repo'] ->
    Package['puppetdb'] ->
    anchor { 'puppetdb::server::install::end': }
}
