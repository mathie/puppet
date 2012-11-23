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
  $precompile_assets = true,
  $asset_compiler    = 'nodejs',
  $bundler_without   = 'development test'
) {
  include git

  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',
  }

  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"
  $rake            = "${bundle_exec} rake"

  case $ruby_version {
    '1.8':   { include rails::deployment::capistrano::ruby18 }
    '1.9':   { include rails::deployment::capistrano::ruby19 }
    default: { fail "Unknown ruby version ${ruby_version}." }
  }

  $app_name = $name
  $username = $name

  # All the various paths that are used/depened upon by Capistrano.
  $base_path            = "/u/apps/${app_name}"
  $current_path         = "${base_path}/current"
  $current_revision     = "${current_path}/REVISION"
  $releases_path        = "${base_path}/releases"
  $default_release_path = "${releases_path}/default"
  $shared_path          = "${base_path}/shared"
  $shared_config_path   = "${shared_path}/config"
  $current_public_path  = "${current_path}/public"
  $current_uploads_path = "${current_public_path}/uploads"
  $shared_uploads_path  = "${shared_path}/uploads"
  $current_log_path     = "${current_path}/log"
  $shared_log_path      = "${shared_path}/log"
  $current_tmp_path     = "${current_path}/tmp"
  $current_pids_path    = "${current_tmp_path}/pids"
  $shared_pids_path     = "${shared_path}/pids"
  $shared_system_path   = "${shared_path}/system"
  $current_system_path  = "${current_public_path}/system"

  $cached_copy                = "${shared_path}/cached-copy"
  $cached_copy_bundler_path   = "${cached_copy}/.bundle"
  $cached_copy_bundler_config = "${cached_copy_bundler_path}/config"

  $shared_bundler_config  = "${shared_config_path}/bundler-config"
  $current_bundler_path   = "${current_path}/.bundle"
  $current_bundler_config = "${current_bundler_path}/config"
  $shared_bundler_install_path = "${shared_path}/bundle"

  $db_dev_install = $db_type ? {
    /mysql2?/    => 'mysql::dev',
    'postgresql' => 'postgresql::dev',
    default      => undef,
  }

  File {
    owner => $username,
    group => $username,
    mode  => '0664',
  }

  file {
    $base_path:
      ensure => directory;

    $releases_path:
      ensure => directory;

    $shared_path:
      ensure => directory;

    $shared_config_path:
      ensure => directory;

    $shared_bundler_install_path:
      ensure => directory;

    $shared_bundler_config:
      ensure  => present,
      content => template('rails/bundler-config.erb');

    $shared_log_path:
      ensure => directory;

    $shared_uploads_path:
      ensure => directory;

    $shared_pids_path:
      ensure => directory;

    $shared_system_path:
      ensure => directory;
  }

  logrotate::log_file {
    $app_name:
      log_file => "${shared_log_path}/*.log",
      days     => 28;
  }

  vcsrepo {
    "${app_name}-repo-cached-copy":
      ensure   => latest,
      revision => $git_branch,
      path     => $cached_copy,
      source   => $git_repo,
      provider => 'git',
      user     => $username,
      require  => [ File[$shared_path], Class['git'] ];
  }

  if defined(File["${app_name}-ssh-private-key"]) {
    File["${app_name}-ssh-private-key"] -> Vcsrepo["${app_name}-repo-cached-copy"]
  }

  exec {
    "create-default-${app_name}-release":
      command => "/bin/cp -R ${cached_copy} ${default_release_path}",
      user    => $username,
      creates => $default_release_path,
      require => [ Vcsrepo["${app_name}-repo-cached-copy"], File[$releases_path] ];
  }

  file {
    $cached_copy_bundler_path:
      ensure  => directory,
      require => Vcsrepo["${app_name}-repo-cached-copy"];

    $cached_copy_bundler_config:
      ensure  => link,
      force   => true,
      target  => $shared_bundler_config,
      require => File[$cached_copy_bundler_path];

    $current_path:
      ensure  => link,
      target  => $default_release_path,
      replace => false,
      require => Exec["create-default-${app_name}-release"];

    $current_public_path:
      ensure  => directory,
      require => File[$current_path];

    $current_system_path:
      ensure  => link,
      target  => $shared_system_path,
      replace => false,
      require => File[$current_public_path];

    $current_log_path:
      ensure  => link,
      force   => true,
      target  => $shared_log_path,
      require => File[$current_path];

    $current_bundler_path:
      ensure  => directory,
      require => File[$current_path];

    $current_bundler_config:
      ensure  => link,
      force   => true,
      target  => $shared_bundler_config,
      require => File[$current_bundler_path];

    $current_uploads_path:
      ensure  => link,
      force   => true,
      target  => $shared_uploads_path,
      require => File[$current_public_path];

    $current_tmp_path:
      ensure  => directory,
      require => File[$current_path];

    $current_pids_path:
      ensure  => link,
      force   => true,
      target  => $shared_pids_path,
      require => File[$current_tmp_path];
  }

  exec {
    "generate-${app_name}-current-revision":
      command => "/usr/bin/git rev-parse --revs-only ${git_branch} > ${current_revision}",
      user    => $username,
      cwd     => $current_path,
      creates => $current_revision,
      require => [ File[$current_path], Package['git'] ];

    "install-${app_name}-gem-bundle":
      command => "${bundler_command} --deployment --quiet --without ${bundler_without} --path ${shared_bundler_install_path}",
      timeout => 0, # May take a stupendous amount of time, it appears.
      user    => $username,
      cwd     => $cached_copy,
      require => [ Vcsrepo["${app_name}-repo-cached-copy"], Package['bundler'], Class[$db_dev_install] ];
  }

  if $precompile_assets {
    include $asset_compiler

    $shared_assets_path  = "${shared_path}/assets"
    $current_assets_path = "${current_public_path}/assets"

    file {
      $shared_assets_path:
        ensure => directory;

      $current_assets_path:
        ensure  => link,
        force   => true,
        target  => $shared_assets_path,
        require => File[$current_public_path];
    }

    exec {
      "asset-precompile-${app_name}":
        command     => "${rake} assets:precompile",
        user        => $username,
        creates     => "${current_assets_path}/manifest-default.json",
        cwd         => $current_path,
        environment => "RAILS_ENV=${rails_env}",
        require     => [ Exec["install-${app_name}-gem-bundle"], File[$current_assets_path], Class[$asset_compiler] ];
    }
  }

  if $db_type {
    $shared_database_yml  = "${shared_config_path}/database.yml"
    $current_database_yml = "${current_path}/config/database.yml"

    if $db_dev_install {
      include $db_dev_install
    }

    file {
      $shared_database_yml:
        ensure  => present,
        content => template('rails/database.yml.erb'),
        require => File[$shared_config_path];

      $current_database_yml:
        ensure  => link,
        target  => $shared_database_yml,
        require => [ File[$current_path], File[$shared_database_yml] ];
    }
  }
}
