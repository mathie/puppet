class puppet::db {
  include puppet::db::install, puppet::db::config, puppet::db::service

  anchor { 'puppet::db::begin': } ->
    Class['puppet::db::install'] ->
    Class['puppet::db::config'] ~>
    Class['puppet::db::service'] ->
    anchor { 'puppet::db::end': }

  # The puppet agent must have been configured and figured out its SSL
  # certificate before the DB can install itself. Otherwise it all goes
  # horribly wrong.
  Class['puppet::master'] -> Class['puppet::db']
  Class['puppet::agent']  -> Class['puppet::db']
}
