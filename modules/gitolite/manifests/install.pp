class gitolite::install {
  $uid = 10130

  group {
    'git':
      ensure    => present,
      gid       => $uid,
      allowdupe => false;
  }

  user {
    'git':
      ensure    => present,
      uid       => $uid,
      gid       => $uid,
      comment   => 'Git version control',
      home      => '/home/git',
      shell     => '/bin/bash',
      allowdupe => false,
      require   => Group['git'];
  }

  vcsrepo {
    'gitolite':
      ensure   => latest,
      revision => 'gl-v304', # FIXME: Check this is right
      path     => '/home/git/gitolite',
      source   => 'git://github.com/gitlabhq/gitolite.git',
      provider => 'git',
      user     => 'git',
      require  => User['git'];
  }

  file {
    '/home/git':
      ensure => directory,
      owner  => git,
      group  => git,
      mode   => '0755';

    '/home/git/bin':
      ensure => directory,
      owner  => git,
      group  => git,
      mode   => '0755';

    '/home/git/repositories':
      ensure => directory,
      owner  => git,
      group  => git,
      mode   => '0775';

    '/home/git/.ssh':
      ensure => directory,
      owner  => git,
      group  => git,
      mode   => '0700';

    '/home/git/.profile':
      ensure => present,
      owner  => git,
      group  => git,
      mode   => '0644',
      source => 'puppet:///modules/gitolite/profile';
  }

  exec {
    'gitolite-ssh-keygen':
      command => '/usr/bin/ssh-keygen -q -N \'\' -t rsa -f /home/git/.ssh/id_rsa',
      user    => git,
      creates => '/home/git/.ssh/id_rsa',
      require => File['/home/git/.ssh'];

    'gitolite-install':
      command => '/home/git/gitolite/install -ln /home/git/bin',
      creates => '/home/git/bin/gitolite',
      user    => git,
      cwd     => '/home/git',
      require => [ Vcsrepo['gitolite'], File['/home/git/bin'] ];
  }

  exec {
    'gitolite-setup':
      command     => '/home/git/bin/gitolite setup -pk /home/git/.ssh/id_rsa.pub',
      creates     => '/home/git/.gitolite',
      user        => git,
      cwd         => '/home/git',
      environment => [
        'HOME=/home/git',
        'PATH=/home/git/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games'
      ],
      require     => [ Vcsrepo['gitolite'], Exec['gitolite-ssh-keygen'] ];
  }
}
