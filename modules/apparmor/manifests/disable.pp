class apparmor::disable {
  exec {
    'apparmor-teardown':
      command     => '/etc/init.d/apparmor teardown',
      refreshonly => true,
  }

  service {
    'apparmor':
      ensure => stopped,
      enable => false;
  }

  Service['apparmor'] ~> Exec['apparmor-teardown']
}
