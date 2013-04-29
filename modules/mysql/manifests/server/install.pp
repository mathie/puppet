class mysql::server::install {
  include mysql::repo, mysql::client

  package {
    'percona-server-server':
      ensure => present;
  }

  Class['mysql::repo'] -> Package['percona-server-server']
}
