class hubot::install {
  include git

  group {
    'hubot':
      ensure    => present,
      gid       => 20006,
      allowdupe => true;
  }

  user {
    'hubot':
      ensure    => present,
      uid       => 20006,
      gid       => 20006,
      comment   => 'Hubot chat bot',
      home      => '/home/hubot',
      shell     => '/bin/bash',
      allowdupe => false,
      require   => Group['hubot'];
  }

  file {
    '/home/hubot':
      ensure => directory,
      owner  => hubot,
      group  => hubot,
      mode   => '0755';

    '/home/hubot/.ssh':
      ensure => directory,
      owner  => hubot,
      group  => hubot,
      mode   => '0700';

    '/home/hubot/.ssh/id_rsa':
      ensure => present,
      owner  => hubot,
      group  => hubot,
      mode   => '0600',
      source => 'puppet:///modules/hubot/hubot.keys';

    '/u':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/u/apps':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/u/apps/hubot':
      ensure => directory,
      owner  => hubot,
      group  => hubot,
      mode   => '0755';

    '/u/apps/hubot/releases':
      ensure => directory,
      owner  => hubot,
      group  => hubot,
      mode   => '0755';
  }

  vcsrepo {
    'hubot':
      ensure   => latest,
      path     => '/u/apps/hubot/releases/latest',
      source   => 'git@github.com:rubaidh/hubot.git',
      revision => 'master',
      provider => 'git',
      user     => 'hubot',
      require  => [
        User['hubot'],
        File['/u/apps/hubot/releases'],
        File['/home/hubot/.ssh/id_rsa'],
        Class['git']
      ];
  }

  file {
    '/u/apps/hubot/current':
      ensure  => link,
      owner   => hubot,
      group   => hubot,
      mode    => '0644',
      target  => '/u/apps/hubot/releases/latest',
      require => Vcsrepo['hubot'];
  }
}
