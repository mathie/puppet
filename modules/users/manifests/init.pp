class users {
  exec {
    'disable-root-user-account':
      command => '/usr/sbin/usermod --lock root',
      unless  => '/bin/grep ^root:! /etc/shadow';
  }
}
