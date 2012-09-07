class graphite {
  # For now, the graphite module assumes it's running on the same host as the
  # collectd master because I'm lazy and don't feel like packaging up collectd
  # 5.1 which has a graphite output module.
  include collectd::master, memcached::server
  include graphite::install, graphite::config, graphite::service

  Class['collectd::master'] -> Class['graphite::install'] -> Class['graphite::config'] ~> Class['graphite::service']
}
