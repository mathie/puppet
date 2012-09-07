define rails::deployment::capistrano(
  $git_repo,
  $git_branch        = 'master',
  $rails_env         = 'production',
  $ruby_version      = '1.9',
  $db_type           = 'mysql2',
  $database          = $name,
  $db_host           = 'localhost',
  $db_username       = $name,
  $db_password       = '',
  $precompile_assets = true
) {
  include git

  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',
  }

  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"
  $rake            = "${bundle_exec} rake"

  class {
    'rails::deployment::capistrano::base':
      ruby_version => $ruby_version;
  }

  $app_name = $name

  $db_build_dep = $db_type ? {
    /mysql2?/    => 'libmysqlclient-dev',
    'postgresql' => 'libpq-dev',
  }

  package {
    $db_build_dep:
      ensure => present;
  }

  File {
    owner => $app_name,
    group => $app_name,
    mode  => '0664',
  }

  file {
    "/u/apps/${app_name}":
      ensure => directory;

    "/u/apps/${app_name}/releases":
      ensure => directory;

    "/u/apps/${app_name}/shared":
      ensure => directory;

    "/u/apps/${app_name}/shared/config":
      ensure => directory;

    "/u/apps/${app_name}/shared/config/database.yml":
      ensure  => present,
      content => template('rails/database.yml.erb');

    "/u/apps/${app_name}/shared/config/bundler-config":
      ensure  => present,
      content => template('rails/bundler-config.erb');

    "/u/apps/${app_name}/shared/log":
      ensure => directory;

    "/u/apps/${app_name}/shared/uploads":
      ensure => directory;

    "/u/apps/${app_name}/shared/assets":
      ensure => directory;

    "/u/apps/${app_name}/shared/pids":
      ensure => directory;
  }

  vcsrepo {
    "${app_name}-repo-cached-copy":
      ensure   => latest,
      revision => $git_branch,
      path     => "/u/apps/${app_name}/shared/cached-copy",
      source   => $git_repo,
      provider => 'git',
      user     => $app_name,
      require  => [ File["/u/apps/${app_name}/shared"], File["${app_name}-ssh-private-key"], Class['git'] ];
  }

  exec {
    "create-default-${app_name}-release":
      command => "/bin/cp -R /u/apps/${app_name}/shared/cached-copy /u/apps/${app_name}/releases/default",
      user    => $app_name,
      creates => "/u/apps/${app_name}/releases/default",
      require => [ Vcsrepo["${app_name}-repo-cached-copy"], File["/u/apps/${app_name}/releases"] ];
  }

  file {
    "/u/apps/${app_name}/shared/cached-copy/.bundle":
      ensure  => directory,
      require => Vcsrepo["${app_name}-repo-cached-copy"];

    "/u/apps/${app_name}/shared/cached-copy/.bundle/config":
      ensure  => link,
      force   => true,
      target  => "/u/apps/${app_name}/shared/config/bundler-config",
      require => File["/u/apps/${app_name}/shared/cached-copy/.bundle"];

    "/u/apps/${app_name}/current":
      ensure  => link,
      target  => "/u/apps/${app_name}/releases/default",
      replace => false,
      require => Exec["create-default-${app_name}-release"];

    "/u/apps/${app_name}/current/log":
      ensure  => link,
      force   => true,
      target  => "/u/apps/${app_name}/shared/log",
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/.bundle":
      ensure  => directory,
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/.bundle/config":
      ensure  => link,
      force   => true,
      target  => "/u/apps/${app_name}/shared/config/bundler-config",
      require => File["/u/apps/${app_name}/current/.bundle"];

    "/u/apps/${app_name}/current/config/database.yml":
      ensure  => link,
      target  => "/u/apps/${app_name}/shared/config/database.yml",
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/public/assets":
      ensure => link,
      force  => true,
      target => "/u/apps/${app_name}/shared/assets",
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/public/uploads":
      ensure  => link,
      force   => true,
      target  => "/u/apps/${app_name}/shared/uploads",
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/tmp":
      ensure  => directory,
      require => File["/u/apps/${app_name}/current"];

    "/u/apps/${app_name}/current/tmp/pids":
      ensure  => link,
      force   => true,
      target  => "/u/apps/${app_name}/shared/pids",
      require => File["/u/apps/${app_name}/current/tmp"];
  }

  exec {
    "generate-${app_name}-current-revision":
      command => "/usr/bin/git rev-parse --revs-only ${git_branch} > /u/apps/${app_name}/current/REVISION",
      user    => $app_name,
      cwd     => "/u/apps/${app_name}/current",
      creates => "/u/apps/${app_name}/current/REVISION",
      require => [ File["/u/apps/${app_name}/current"], Package['git'] ];

    "install-${app_name}-gem-bundle":
      command => "${bundler_command} --deployment --quiet --without development,test --path /u/apps/${app_name}/shared/bundle",
      user    => $app_name,
      cwd     => "/u/apps/${app_name}/shared/cached-copy",
      require => [ Vcsrepo["${app_name}-repo-cached-copy"], Package['bundler'], Package[$db_build_dep] ];
  }

  if $precompile_assets {
    # I feel dirty installing nodejs, but it seems to be the easiest JS runtime
    # to get from the upstream package repo.
    package {
      'nodejs':
        ensure => present;
    }

    exec {
      "asset-precompile-${app_name}":
        command => "${rake} assets:precompile",
        user    => $app_name,
        creates => "/u/apps/${app_name}/current/public/assets/application.css",
        cwd     => "/u/apps/${app_name}/current",
        require => [ Exec["install-${app_name}-gem-bundle"], File["/u/apps/${app_name}/current/public/assets"], Package['nodejs'] ];
    }
  }
}
