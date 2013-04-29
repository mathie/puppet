class puppet::master::config($ssh_key, $git_repo) {
  include git
  include ssh::client
  include puppet::config

  File {
    ensure => present,
    owner  => puppet,
    group  => puppet,
    mode   => '0644',
  }

  if $::vagrant == 'true' {
    file {
      '/etc/puppet/autosign.conf':
        source => 'puppet:///modules/puppet/autosign.conf';
    }
  } else {
    file {
      '/etc/puppet/autosign.conf':
        ensure => absent;
    }
  }

  file {
    '/etc/puppet/puppetdb.conf':
      content => template('puppet/puppetdb.conf.erb');

    '/etc/puppet/routes.yaml':
      source => 'puppet:///modules/puppet/routes.yaml';

    '/var/lib/puppet':
      ensure => directory,
      mode   => '0755';
  }

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
      source => $ssh_key;
  }

  vcsrepo {
    'puppet-master-repo':
      ensure   => latest,
      revision => 'master',
      path     => '/etc/puppet/repo',
      source   => $git_repo,
      provider => 'git',
      require  => [ File['/root/.ssh/id_rsa'], Class['git'] ],
      notify   => Exec['touch-site-pp'];
  }

  exec {
    'touch-site-pp':
      command     => '/usr/bin/touch /etc/puppet/manifests/site.pp',
      refreshonly => true;
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

  Class['puppet::config'] -> Class['puppet::master::service']
}
