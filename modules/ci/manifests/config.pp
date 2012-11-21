class ci::config {
  file {
    '/var/lib/jenkins/.ssh':
      ensure => directory,
      owner  => jenkins,
      group  => nogroup,
      mode   => '0700';

    '/var/lib/jenkins/.ssh/id_rsa':
      ensure => present,
      owner  => jenkins,
      group  => nogroup,
      mode   => '0600',
      source => 'puppet:///modules/ci/jenkins.keys';

    '/var/lib/jenkins/.gitconfig':
      ensure => present,
      owner  => jenkins,
      group  => nogroup,
      mode   => '0644',
      source => 'puppet:///modules/ci/gitconfig';
  }

  Class['jenkins'] -> Class['ci::config']
}
