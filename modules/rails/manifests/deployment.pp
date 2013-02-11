define rails::deployment(
  $uid,
  $git_repo,
  $ssh_private_key     = undef,
  $ssh_authorized_keys = undef,
  $ruby_version        = '1.9',
  $rails_env           = 'production',
  $git_branch          = 'master',
  $comment             = "${name} app server",
  $db_type             = 'mysql2',
  $precompile_assets   = true,
  $asset_compiler      = 'nodejs',
  $bundler_without     = 'development test'
) {
  $app_name = $name

  rails::deployment::user {
    $app_name:
      uid                 => $uid,
      comment             => $comment,
      ssh_private_key     => $ssh_private_key,
      ssh_authorized_keys => $ssh_authorized_keys;
  }

  rails::deployment::capistrano {
    $app_name:
      git_repo          => $git_repo,
      git_branch        => $git_branch,
      ruby_version      => $ruby_version,
      rails_env         => $rails_env,
      db_type           => $db_type,
      precompile_assets => $precompile_assets,
      asset_compiler    => $asset_compiler,
      bundler_without   => $bundler_without;
  }

  Rails::Deployment::User[$app_name] -> Rails::Deployment::Capistrano[$app_name]

  file {
    "/etc/init/${app_name}.conf":
      ensure  => present,
      content => template('rails/upstart-master.conf.erb');
  }

  service {
    $app_name:
      ensure  => running,
      enable  => true,
      require => File["/etc/init/${app_name}.conf"];
  }
}
