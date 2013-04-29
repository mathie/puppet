class puppet::dashboard::install {
  include ruby::ruby18
  include mysql::client

  package {
    'daemons':
      ensure   => '1.0.10',
      provider => 'gem18';

    'rack':
      ensure   => '1.1.6',
      provider => 'gem18';

    'mongrel':
      ensure   => present,
      provider => 'gem18';

    # Puppet dashboard requires mysql-client to be installed. The package it
    # attempts to install is mysql-client to satisfy that dependency. However,
    # we provide it with percona-server-client. So that needs to be installed
    # first to prevent problems.
    #
    # And, for bonus points, the version of rack specified above is closely
    # linked to the version of Rails that puppet dashboard relies on, so in
    # order to not suffer pain, I'm fixing the version for now.
    'puppet-dashboard':
      ensure  => '1.2.22-1puppetlabs1',
      require => Class['mysql::client'];
  }
}
