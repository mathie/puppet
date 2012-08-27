class redis::server {
  include redis::server::install, redis::server::config, redis::server::service
  Class['redis::server::install'] -> Class['redis::server::config'] ~> Class['redis::server::service']
}
