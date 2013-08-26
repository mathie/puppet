class mysql::server::firewall {
  @firewall::allow {
    'mysql':
      port    => '3306',
      sources => $mysql::server::clients;
  }
}
