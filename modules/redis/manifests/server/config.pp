class redis::server::config {
  firewall::allow {
    'redis':
      port => 6379;
  }
}
