class digi::install {
  include git
  include rails::deployment::capistrano::ruby18
  include ssl::dev

  $username   = 'digi'
  $app_name   = 'digi'
  $git_repo   = 'git@github.com:tayeco/em-idigi.git'
  $git_branch = 'master'

  users::account {
    $username:
      ensure              => present,
      uid                 => 20010,
      ssh_authorized_keys => '',
      ssh_private_key     => 'puppet:///modules/users/keys/digi-deploy.keys',
      comment             => 'Digi Poller';
  }

  $ruby_command    = '/usr/bin/ruby1.8'
  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"
  $rake            = "${bundle_exec} rake"

  $bundler_without = 'development test'

  $base_path            = "/u/apps/${app_name}"
  $current_path         = "${base_path}/current"
  $current_revision     = "${current_path}/REVISION"
  $releases_path        = "${base_path}/releases"
  $default_release_path = "${releases_path}/default"
  $shared_path          = "${base_path}/shared"
  $shared_config_path   = "${shared_path}/config"
  $current_public_path  = "${current_path}/public"
  $current_log_path     = "${current_path}/log"
  $shared_log_path      = "${shared_path}/log"
  $current_tmp_path     = "${current_path}/tmp"

  $cached_copy                = "${shared_path}/cached-copy"
  $cached_copy_bundler_path   = "${cached_copy}/.bundle"
  $cached_copy_bundler_config = "${cached_copy_bundler_path}/config"

  $shared_bundler_config  = "${shared_config_path}/bundler-config"
  $current_bundler_path   = "${current_path}/.bundle"
  $current_bundler_config = "${current_bundler_path}/config"
  $shared_bundler_install_path = "${shared_path}/bundle"

  File {
    owner => 'digi',
    group => 'digi',
    mode  => '0644',
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
      require  => [ File["/home/${app_name}/.ssh/id_rsa"], File[$shared_path], Class['git'] ];
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

    $current_tmp_path:
      ensure  => directory,
      require => File[$current_path];

    "${current_tmp_path}/display_files":
      ensure  => directory,
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
      command     => "${bundler_command} --deployment --quiet --without ${bundler_without} --path ${shared_bundler_install_path}",
      timeout     => 0, # May take a stupendous amount of time, it appears.
      user        => $username,
      cwd         => $cached_copy,
      refreshonly => true,
      require     => [ Vcsrepo["${app_name}-repo-cached-copy"], Package['bundler18'], Class['ssl::dev'] ];
  }

  Vcsrepo["${app_name}-repo-cached-copy"] ~> Exec["install-${app_name}-gem-bundle"]
}
