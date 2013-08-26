class rsyslog::server(
  $clients = undef
) {
  include rsyslog::server::firewall,
    rsyslog::install,
    rsyslog::server::config,
    rsyslog::service

  anchor { 'rsyslog::server::begin': } ->
    Class['rsyslog::server::firewall'] ->
    Class['rsyslog::install'] ->
    Class['rsyslog::server::config'] ~>
    Class['rsyslog::service'] ->
    anchor { 'rsyslog::server::end': }
}
