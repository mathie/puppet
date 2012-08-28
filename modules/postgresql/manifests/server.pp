class postgresql::server {
  include postgresql::server::install, postgresql::server::config, postgresql::server::service

  Class['postgresql::server::install'] -> Class['postgresql::server::config'] ~> Class['postgresql::server::service']
}
