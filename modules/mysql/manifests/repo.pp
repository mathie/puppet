class mysql::repo {
  include apt

  apt::repository {
    'percona':
      source => 'puppet:///modules/mysql/percona-sources.list';
  }

  apt::key {
    'percona-public-key':
      keyid => 'CD2EFD2A';
  }
}
