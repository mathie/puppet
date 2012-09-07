class ntp::server {
  include ntp::server::install, ntp::server::config, ntp::server::service

  Class['ntp::server::install'] -> Class['ntp::server::config'] ~> Class['ntp::server::service']
  Class['apparmor::disable'] -> Class['ntp::server::service']
}
