class mysql::repo($stage = first) {
  apt::repository {
    'percona':
      url   => 'http://repo.percona.com/apt',
      keyid => 'CD2EFD2A';
  }

  file {
    '/etc/apt/preferences.d/pin-percona':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/mysql/apt-preferences-pin-percona';
  }
}
