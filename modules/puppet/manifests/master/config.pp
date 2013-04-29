class puppet::master::config {
  include git
  include ssh::client
  include puppet::config

  File {
    ensure => present,
    owner  => puppet,
    group  => puppet,
    mode   => '0644',
  }

  concat::fragment {
    'puppet-conf-master':
      file    => 'puppet.conf',
      content => template('puppet/puppet-master.conf.erb');
  }

  $autosign_ensure = $::vagrant ? {
    'true'  => present,
    default => absent,
  }

  file {
    '/etc/puppet/autosign.conf':
      ensure  => $autosign_ensure,
      content => "*\n";

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
      source => $puppet::master::ssh_key;
  }

  vcsrepo {
    'puppet-master-repo':
      ensure   => latest,
      revision => 'master',
      path     => '/etc/puppet/repo',
      source   => $puppet::master::git_repo,
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

  anchor { 'puppet::master::config::begin': } ->
    Class['puppet::config'] ->
    anchor { 'puppet::master::config::end': }
}
