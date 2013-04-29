class mysql::server::backup::install {
  include mysql::repo

  package {
    'percona-xtrabackup':
      ensure => present;

    's3cmd':
      ensure => present;
  }

  Class['mysql::repo'] -> Exec['apt-get-update'] -> Package['percona-xtrabackup']
}
