class ssh::server::config {
  firewall::allow {
    'ssh':
      port => '22';
  }
}
