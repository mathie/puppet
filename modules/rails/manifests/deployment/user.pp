define rails::deployment::user($uid, $comment, $ssh_private_key, $ssh_authorized_keys) {
  $username = $name

  group {
    $username:
      ensure    => present,
      gid       => $uid,
      allowdupe => false;
  }

  user {
    $username:
      ensure    => present,
      uid       => $uid,
      gid       => $uid,
      comment   => $comment,
      home      => "/home/${username}",
      shell     => '/bin/bash',
      allowdupe => false,
      require   => Group[$username];
  }

  sudo::user {
    "${username}-can-restart-app-services":
      user        => $username,
      commands    => "/usr/sbin/service ${username} stop, /usr/sbin/service ${username} start, /usr/sbin/service ${username} restart",
      no_password => true;
  }

  User[$username] -> Sudo::User["${username}-can-restart-app-services"]

  File {
    owner   => $username,
    group   => $username,
    mode    => '0600',
    require => User[$username],
  }

  file {
    "/home/${username}":
      ensure  => directory;

    "/home/${username}/.ssh":
      ensure => directory;

    "${username}-ssh-private-key":
      ensure => present,
      path   => "/home/${username}/.ssh/id_rsa",
      source => $ssh_private_key;

    "${username}-ssh-authorized-keys":
      ensure => present,
      path   => "/home/${username}/.ssh/authorized_keys",
      source => $ssh_authorized_keys;
  }
}
