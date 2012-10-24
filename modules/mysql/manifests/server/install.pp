class mysql::server::install {
  include mysql::repo, mysql::client

  package {
    'percona-server-server':
      ensure => present;
  }

  # FIXME: I'm trying to convince the apt-get update to happen (if necessary)
  # before the package install. This doesn't feel like an elegant way, though.
  Class['mysql::repo'] -> Package['percona-server-server']
}
