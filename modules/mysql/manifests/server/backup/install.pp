class mysql::server::backup::install {
  include mysql::repo

  package {
    'percona-xtrabackup':
      ensure => present;

    's3cmd':
      ensure => present;
  }
}
