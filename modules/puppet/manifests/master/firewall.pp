class puppet::master::firewall {
  @firewall::allow {
    'puppetmaster':
      port    => 8140,
      sources => $puppet::master::clients;
  }
}
