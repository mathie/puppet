class mysql::client {
  include mysql::repo

  package {
    'percona-server-client':
      ensure => present;
  }
}
