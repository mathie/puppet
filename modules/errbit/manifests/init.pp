class errbit {
  include libxml::dev

  package {
    'libcurl4-openssl-dev':
      ensure => present;
  }

  rails::deployment {
    'errbit':
      ruby_version => '1.9',
      rails_env    => 'production',
      uid          => 20006,
      git_repo     => 'git://github.com/errbit/errbit.git',
      db_type      => undef;
  }

  rails::unicorn {
    'errbit':
  }

  file {
    '/u/apps/errbit/shared/config/config.yml':
      ensure  => present,
      owner   => errbit,
      group   => errbit,
      mode    => '0644',
      content => template('errbit/config.yml.erb'),
      require => File['/u/apps/errbit/shared/config'];

    '/u/apps/errbit/current/config/config.yml':
      ensure  => link,
      owner   => errbit,
      group   => errbit,
      mode    => '0644',
      target  => '/u/apps/errbit/shared/config/config.yml',
      require => [
        File['/u/apps/errbit/shared/config/config.yml'],
        File['/u/apps/errbit/current']
      ];

    '/u/apps/errbit/shared/config/mongoid.yml':
      ensure  => present,
      owner   => errbit,
      group   => errbit,
      mode    => '0644',
      content => template('errbit/mongoid.yml.erb'),
      require => File['/u/apps/errbit/shared/config'];

    '/u/apps/errbit/current/config/mongoid.yml':
      ensure  => link,
      owner   => errbit,
      group   => errbit,
      mode    => '0644',
      target  => '/u/apps/errbit/shared/config/mongoid.yml',
      require => [
        File['/u/apps/errbit/shared/config/mongoid.yml'],
        File['/u/apps/errbit/current']
      ];
  }

  File['/u/apps/errbit/current/config/config.yml'] -> Exec['asset-precompile-errbit']
  File['/u/apps/errbit/current/config/mongoid.yml'] -> Exec['asset-precompile-errbit']
}
