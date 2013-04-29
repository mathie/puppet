class puppet::repo {
  apt::repository {
    'puppetlabs':
      url        => 'http://apt.puppetlabs.com/',
      components => [ 'main', 'dependencies' ],
      keyid      => '4BD6EC30';
  }
}
