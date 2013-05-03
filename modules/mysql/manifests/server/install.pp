class mysql::server::install {
  include mysql::repo, mysql::client

  package {
    'percona-server-server':
      ensure => present;
  }
}
