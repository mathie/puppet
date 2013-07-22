class chat::code {
  rails::deployment {
    'chat':
      uid                 => 20003,
      git_repo            => 'git@github.com:rubaidh/chat.git',
      ssh_private_key     => 'puppet:///modules/users/keys/chat-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      db_type             => undef;
  }
}
