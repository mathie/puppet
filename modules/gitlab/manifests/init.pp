class gitlab($database, $db_username, $db_password = '', $rails_env = 'production') {
  include libxml::dev, gitolite, pygments

  package {
    'libicu-dev':
      ensure => present;
  }

  rails::deployment {
    'gitlab':
      ruby_version    => '1.9',
      rails_env       => $rails_env,
      uid             => 20005,
      git_repo        => 'git://github.com/gitlabhq/gitlabhq.git',
      git_branch      => 'stable',
      ssh_private_key => '/home/git/.ssh/id_rsa',
      database        => $database,
      db_type         => 'mysql2',
      db_host         => 'localhost',
      db_username     => $db_username,
      db_password     => $db_password,
      bundler_without => 'development test postgres sqlite';
  }

  # We need gitolite to generate it's ssh key so we can use it.
  Exec['gitolite-ssh-keygen'] -> Rails::Deployment['gitlab']

  rails::unicorn {
    'gitlab':
  }

  rails::resque {
    'gitlab':
  }

  Rails::Deployment['gitlab'] -> Rails::Unicorn['gitlab']
  Rails::Deployment['gitlab'] -> Rails::Resque['gitlab']

  exec {
    'create-gitlab-schema':
      command     => '/usr/bin/ruby1.9.1 -S bundle exec rake gitlab:app:setup',
      environment => [
        'RAILS_ENV=production',
        'HOME=/home/gitlab'
      ],
      cwd         => '/u/apps/gitlab/current',
      user        => gitlab,
      refreshonly => true,
      require     => [
        Mysql::Server::Database[$database],
        File['/u/apps/gitlab/current/config/database.yml'],
        File['/u/apps/gitlab/current/config/gitlab.yml']
      ];
  }

  Mysql::Server::Database[$database] ~> Exec['create-gitlab-schema']
  Exec['install-gitlab-gem-bundle'] -> Exec['create-gitlab-schema']

  file {
    '/u/apps/gitlab/shared/config/gitlab.yml':
      ensure  => present,
      owner   => gitlab,
      group   => gitlab,
      mode    => '0644',
      content => template('gitlab/gitlab.yml.erb'),
      require => File['/u/apps/gitlab/shared/config'];

    '/u/apps/gitlab/current/config/gitlab.yml':
      ensure  => link,
      owner   => gitlab,
      group   => gitlab,
      mode    => '0644',
      target  => '/u/apps/gitlab/shared/config/gitlab.yml',
      require => [ File['/u/apps/gitlab/current'], File['/u/apps/gitlab/shared/config/gitlab.yml'] ];
  }

  File['/u/apps/gitlab/current/config/gitlab.yml'] -> Exec['asset-precompile-gitlab']

  file {
    '/home/gitlab/.gitconfig':
      ensure  => present,
      owner   => gitlab,
      group   => gitlab,
      mode    => '0644',
      content => template('gitlab/gitconfig.erb'),
      require => File['/home/gitlab'];

    '/home/git/.gitolite/hooks/common/post-receive':
      ensure  => present,
      owner   => git,
      group   => git,
      mode    => '0755',
      source  => '/u/apps/gitlab/current/lib/hooks/post-receive',
      require => [ File['/u/apps/gitlab/current'], Exec['gitolite-setup'] ];
  }

  exec {
    'add-git-to-gitlab-group':
      command => '/usr/sbin/adduser git gitlab',
      unless  => '/usr/bin/groups git |grep gitlab',
      require => [ User['git'], Group['gitlab'] ];

    'add-gitlab-to-git-group':
      command => '/usr/sbin/adduser gitlab git',
      unless  => '/usr/bin/groups gitlab |grep \'git\>\'',
      require => [ User['gitlab'], Group['git'] ];
  }

  Class['libxml::dev'] -> Class['gitlab']
  Class['gitolite']    -> Class['gitlab']
}