class collectd::agent::config {
  include collectd::config
  include collectd::plugins::agent

  Class['collectd::config'] -> Class['collectd::plugins::agent'] ~> Class['collectd::service']
}
