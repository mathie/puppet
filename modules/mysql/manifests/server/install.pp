class mysql::server::install {
  include mysql::repo

  package {
    'percona-server-server':
      ensure => present;
  }
}
