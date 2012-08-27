class puppet::repo {
  include apt

  apt::repository {
    'puppetlabs':
      source => 'puppet:///modules/puppet/sources.list';
  }

  apt::key {
    'puppetlabs-public-key':
      keyid => '4BD6EC30';
  }
}
