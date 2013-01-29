define users::account(
  $uid,
  $comment,
  $password            = '*',
  $groups              = [],
  $ensure              = present,
  $shell               = '/bin/bash',
  $ssh_authorized_keys = "puppet:///modules/users/keys/${name}.keys.pub",
  $sudo                = false
) {
  $username = $name

  group { $username:
    ensure    => $ensure,
    gid       => $uid,
    allowdupe => false,
  }

  user { $username:
    ensure    => $ensure,
    password  => $password,
    uid       => $uid,
    gid       => $uid,
    groups    => $groups,
    comment   => $comment,
    home      => "/home/${name}",
    shell     => $shell,
    allowdupe => false,
    require   => Group[$username],
  }

  if $sudo {
    sudo::user {
      "${username}-is-all-powerful":
        user => $username;
    }
  }

  case $ensure {
    present: {
      $home_owner = $username
      $home_group = $username
    }
    default: {
      $home_owner = 'nobody'
      $home_group = 'nogroup'
    }
  }

  File {
    owner => $home_owner,
    group => $home_group,
    mode  => '0600',
  }

  file {
    "/home/${username}":
      ensure  => directory,
      require => User[$username];
  }

  if $ssh_authorized_keys {
    file {
      "/home/${username}/.ssh":
        ensure  => directory,
        require => File["/home/${username}"];

      "/home/${username}/.ssh/authorized_keys":
        ensure  => $ensure,
        source  => $ssh_authorized_keys,
        require => File["/home/${username}/.ssh"];
    }
  }
}
