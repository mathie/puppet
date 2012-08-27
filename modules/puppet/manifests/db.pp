class puppet::db {
  include puppet::db::params
  include puppet::db::install, puppet::db::config, puppet::db::service
  Class['puppet::db::install'] -> Class['puppet::db::config'] ~> Class['puppet::db::service']

  # The puppet agent must have been configured and figured out its SSL
  # certificate before the DB can install itself. Otherwise it all goes
  # horribly wrong.
  Class['puppet::master::service'] -> Class['puppet::agent::service'] -> Class['puppet::db::install']
}
