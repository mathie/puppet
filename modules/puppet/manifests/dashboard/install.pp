class puppet::dashboard::install {
  include ruby::ruby18
  include mysql::client

  package {
    'daemons':
      ensure   => '1.0.10',
      provider => 'gem18';

    'rack':
      ensure   => '1.1.2',
      provider => 'gem18';

    'mongrel':
      ensure   => present,
      provider => 'gem18';

    # Puppet dashboard requires mysql-client to be installed. The package it
    # attempts to install is mysql-client to satisfy that dependency. However,
    # we provide it with percona-server-client. So that needs to be installed
    # first to prevent problems.
    'puppet-dashboard':
      ensure  => present,
      require => Class['mysql::client'];
  }
}
