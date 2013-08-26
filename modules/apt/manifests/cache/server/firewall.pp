class apt::cache::server::firewall {
  @firewall::allow {
    'apt-cacher-ng':
      port    => '3142',
      sources => $apt::cache::server::clients;
  }
}
