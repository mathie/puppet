define rails::deployment(
  $uid,
  $git_repo,
  $ssh_private_key,
  $ssh_authorized_keys,
  $ruby_version      = '1.9',
  $rails_env         = 'production',
  $git_branch        = 'master',
  $comment           = "${name} app server",
  $db_type           = 'mysql2',
  $database          = $name,
  $db_host           = 'localhost',
  $db_username       = $name,
  $db_password       = '',
  $precompile_assets = true,
  $asset_compiler    = 'nodejs'
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
      database          => $database,
      db_host           => $db_host,
      db_username       => $db_username,
      db_password       => $db_password,
      precompile_assets => $precompile_assets,
      asset_compiler    => $asset_compiler;
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
