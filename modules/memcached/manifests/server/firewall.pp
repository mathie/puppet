class memcached::server::firewall {
  @firewall::allow {
    'memcached':
      port    => '11211',
      sources => $memcached::server::clients;
  }
}
