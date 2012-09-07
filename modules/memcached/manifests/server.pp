class memcached::server {
  include memcached::server::install, memcached::server::config, memcached::server::service

  Class['memcached::server::install'] -> Class['memcached::server::config'] ~> Class['memcached::server::service']
}
