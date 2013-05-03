define users::account(
  $uid                 = 65534,
  $comment             = $name,
  $password            = '*',
  $htpasswd            = undef,
  $groups              = [],
  $ensure              = present,
  $shell               = '/bin/bash',
  $ssh_authorized_keys = "puppet:///modules/users/keys/${name}.keys.pub",
  $ssh_private_key     = undef,
  $email               = undef,
  $sudo                = false
) {
  $username = $name

  # If the user is being removed, then just stop managing the group for now.
  # Attempting to ensure it's absent fails because it's the primary group for
  # the user.
  if $ensure == present {
    group { $username:
      ensure    => $ensure,
      gid       => $uid,
      allowdupe => false,
    }
  }

  $user_require = $ensure ? {
    present => Group[$username],
    default => undef,
  }

  user {
    $username:
      ensure    => $ensure,
      password  => $password,
      uid       => $uid,
      gid       => $uid,
      groups    => $groups,
      comment   => $comment,
      home      => "/home/${name}",
      shell     => $shell,
      allowdupe => false,
      require   => $user_require;
  }

  if $email and $email != '' {
    @nagios_contact {
      $username:
        ensure => $ensure,
        alias  => $comment,
        email  => $email;
    }
  }

  if $sudo {
    sudo::user {
      "${username}-is-all-powerful":
        user => $username;
    }
  }

  if $htpasswd {
    nginx::user {
      $username:
        ensure   => $ensure,
        password => $htpasswd;
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
      mode    => '0755',
      require => User[$username];

    "/home/${username}/.ssh":
      ensure  => directory,
      require => File["/home/${username}"];
  }

  if $ensure == present and $ssh_authorized_keys {
    file {
      "/home/${username}/.ssh/authorized_keys":
        ensure  => present,
        source  => $ssh_authorized_keys,
        require => File["/home/${username}/.ssh"];
    }
  } else {
    file {
      "/home/${username}/.ssh/authorized_keys":
        ensure => absent;
    }
  }

  if $ensure == present and $ssh_private_key {
    file {
      "/home/${username}/.ssh/id_rsa":
        ensure  => present,
        source  => $ssh_private_key,
        require => File["/home/${username}/.ssh"];
    }
  } else {
    file {
      "/home/${username}/.ssh/id_rsa":
        ensure => absent;
    }
  }
}
