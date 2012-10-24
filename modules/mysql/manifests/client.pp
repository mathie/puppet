class mysql::client {
  include mysql::repo

  package {
    'percona-server-client':
      ensure => present;
  }

  Class['mysql::repo'] -> Exec['apt-get-update'] -> Package['percona-server-client']
}
