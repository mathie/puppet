class collectd::master {
  include collectd::install, collectd::master::config, collectd::service

  Class['collectd::install'] -> Class['collectd::master::config'] ~> Class['collectd::service']
}
