class puppet::master::repo {
  file {
    '/root/.ssh':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0700';

    '/root/.ssh/id_rsa':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0600',
      source => $puppet::master::ssh_key;
  }

  if $::vagrant == 'true' {
    file {
      '/etc/puppet/modules':
        ensure => link,
        force  => true,
        target => '/vagrant/modules';

      '/etc/puppet/manifests':
        ensure => link,
        force  => true,
        target => '/vagrant/manifests';
    }
  } else {
    vcsrepo {
      'puppet-master-repo':
        ensure   => latest,
        revision => 'master',
        path     => '/etc/puppet/repo',
        source   => $puppet::master::git_repo,
        provider => 'git',
        require  => [ File['/root/.ssh/id_rsa'], Class['git'] ];
    }

    file {
      '/etc/puppet/modules':
        ensure  => link,
        force   => true,
        target  => '/etc/puppet/repo/modules',
        require => Vcsrepo['puppet-master-repo'];

      '/etc/puppet/manifests':
        ensure  => link,
        force   => true,
        target  => '/etc/puppet/repo/manifests',
        require => Vcsrepo['puppet-master-repo'];
    }
  }

  exec {
    'touch-site-pp':
      command => '/usr/bin/touch /etc/puppet/manifests/site.pp',
      unless  => '/usr/bin/test -z $(/usr/bin/find /etc/puppet/manifests/ -follow -newer /etc/puppet/manifests/site.pp)',
      require => File['/etc/puppet/manifests'];
  }
}
