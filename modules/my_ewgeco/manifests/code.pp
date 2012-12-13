class my_ewgeco::code($database, $db_host, $db_username, $db_password, $rails_env = 'production') {
  include libxml::dev, imagemagick::dev

  rails::deployment {
    'my_ewgeco':
      ruby_version        => '1.9',
      rails_env           => $rails_env,
      uid                 => 20002,
      git_repo            => 'git@github.com:tayeco/my_ewgeco.git',
      git_branch          => 'rails-3.2',
      ssh_private_key     => 'puppet:///modules/my_ewgeco/my-ewgeco-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      database            => $database,
      db_type             => 'mysql2',
      db_host             => $db_host,
      db_username         => $db_username,
      db_password         => $db_password;
  }

  Class['libxml::dev']      -> Class['my_ewgeco::code']
  Class['imagemagick::dev'] -> Class['my_ewgeco::code']
}
