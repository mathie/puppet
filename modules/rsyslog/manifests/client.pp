class rsyslog::client {
  include rsyslog::install, rsyslog::client::config, rsyslog::service
  Class['rsyslog::install'] -> Class['rsyslog::client::config'] ~> Class['rsyslog::service']
}
