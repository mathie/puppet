define rails::deployment($uid, $git_repo, $ssh_private_key, $ssh_authorized_keys, $rails_env = 'production', $git_branch = 'master', $comment = "${name} app server", $database = $name, $db_host = 'localhost', $db_username = $name, $db_password = '') {
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
      git_repo    => $git_repo,
      git_branch  => $git_branch,
      rails_env   => $rails_env,
      database    => $database,
      db_host     => $db_host,
      db_username => $db_username,
      db_password => $db_password;
  }

  Rails::Deployment::User[$app_name] -> Rails::Deployment::Capistrano[$app_name]
}
