class rsyslog::server::firewall {
  @firewall::allow {
    'rsyslog-ssl':
      port    => '10514',
      sources => $rsyslog::server::clients;
  }
}
