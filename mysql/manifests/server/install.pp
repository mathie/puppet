class mysql::server::install {
  include apt

  apt::repository {
    'percona':
      source => 'puppet:///modules/mysql/percona-sources.list';
  }

  apt::key {
    'percona-public-key':
      keyid => 'CD2EFD2A';
  }

  package {
    'percona-server-server-5.5':
      ensure => present;

    'percona-server-client-5.5':
      ensure => present;
  }

  # FIXME: I'm trying to convince the apt-get update to happen (if necessary)
  # before the package install. This doesn't feel like an elegant way, though.
  Apt::Repository['percona'] -> Apt::Key['percona-public-key'] -> Exec['apt-get-update'] -> Package['percona-server-server-5.5']
  Apt::Repository['percona'] -> Apt::Key['percona-public-key'] -> Exec['apt-get-update'] -> Package['percona-server-client-5.5']
}
