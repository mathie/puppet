class postgresql::server {
  include postgresql::client
  include postgresql::server::install, postgresql::server::config, postgresql::server::service

  Class['postgresql::client'] -> Class['postgresql::server::install'] -> Class['postgresql::server::config'] ~> Class['postgresql::server::service']
}
