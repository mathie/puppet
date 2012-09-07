class collectd::master::config {
  include collectd::config
  include collectd::plugins::master

  Class['collectd::config'] -> Class['collectd::plugins::master'] ~> Class['collectd::service']
}
