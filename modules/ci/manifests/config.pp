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
  }

  Class['jenkins'] -> Class['ci::config']
}
