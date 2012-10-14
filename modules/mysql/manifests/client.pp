class mysql::client {
  package {
    'percona-server-client':
      ensure => present;
  }
}
