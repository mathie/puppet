class collectd::master(
  $clients = undef
) {
  include collectd::master::firewall, collectd::install, collectd::master::config, collectd::service

  anchor { 'collectd::master::begin': } ->
    Class['collectd::master::firewall'] ->
    Class['collectd::install'] ->
    Class['collectd::master::config'] ~>
    Class['collectd::service'] ->
    anchor { 'collectd::master::end': }
}
