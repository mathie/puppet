class users {
  exec {
    'disable-root-user-account':
      command => '/usr/sbin/usermod --lock root',
      unless  => '/bin/grep ^root:! /etc/shadow';
  }

  users::account {
    'mathie':
      uid      => 10001,
      password => '$6$sIQnqvVz$LOocGXi65myfyIne7knOr0KL0QkjReLbuSe9Fe5ct.jGOVTWf6NID4toF6Pkm5I5nRldC4CtcC.kyLo6ddZKQ0',
      comment  => 'Graeme Mathieson',
      sudo     => true;
  }
}
