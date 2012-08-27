class puppetmaster {
  include puppet::db

  class {
    'puppet::master':
      ssh_key  => 'puppet:///modules/users/keys/root.keys',
      git_repo => 'git@github.com:rubaidh/puppet.git';
  }
}
