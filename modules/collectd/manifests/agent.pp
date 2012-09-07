class collectd::agent {
  include collectd::install, collectd::agent::config, collectd::service

  Class['collectd::install'] -> Class['collectd::agent::config'] ~> Class['collectd::service']
}
