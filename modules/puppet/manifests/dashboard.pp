class puppet::dashboard {
  include mysql::server

  include puppet::dashboard::install, puppet::dashboard::config, puppet::dashboard::service

  Class['puppet::dashboard::install'] -> Class['puppet::dashboard::config'] ~> Class['puppet::dashboard::service']
}
