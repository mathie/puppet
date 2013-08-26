class memcached::server(
  $clients = [ '127.0.0.1' ]
) {
  include memcached::server::firewall, memcached::server::install, memcached::server::config, memcached::server::service

  anchor { 'memcached::server::begin': } ->
    Class['memcached::server::firewall'] ->
    Class['memcached::server::install'] ->
    Class['memcached::server::config'] ~>
    Class['memcached::server::service'] ->
    anchor { 'memcached::server::end': }
}
