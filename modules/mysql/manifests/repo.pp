class mysql::repo {
  apt::repository {
    'percona':
      url   => 'http://repo.percona.com/apt',
      keyid => 'CD2EFD2A';
  }
}
