class puppetdb::server {
  include puppetdb::server::install, puppetdb::server::config, puppetdb::server::service

  anchor { 'puppetdb::server::begin': } ->
    Class['puppetdb::server::install'] ->
    Class['puppetdb::server::config'] ~>
    Class['puppetdb::server::service'] ->
    anchor { 'puppetdb::server::end': }

  # The puppet agent must have been configured and figured out its SSL
  # certificate before the DB can install itself. Otherwise it all goes
  # horribly wrong.
  Class['puppet::master'] -> Class['puppetdb::server']
  Class['puppet::agent']  -> Class['puppetdb::server']
}
