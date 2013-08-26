class collectd::master::firewall {
  @firewall::allow {
    'collectd-master':
      proto   => 'udp',
      port    => 25826,
      sources => $collectd::master::clients;
  }
}
