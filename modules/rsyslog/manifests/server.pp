class rsyslog::server {
  include rsyslog::install, rsyslog::server::config, rsyslog::service
  Class['rsyslog::install'] -> Class['rsyslog::server::config'] ~> Class['rsyslog::service']
}
