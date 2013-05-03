define sudo::user($user, $commands = 'ALL', $no_password = false, $hosts = 'ALL', $as = 'ALL') {
  include sudo

  if $no_password {
    $no_password_string = 'NOPASSWD:'
  } else {
    $no_password_string = ''
  }

  concat::fragment {
    "${user}-${hosts}-${as}-${commands}":
      file    => 'sudoers',
      content => "${user} ${hosts} = (${as}) ${no_password_string} ${commands}\n";
  }
}
