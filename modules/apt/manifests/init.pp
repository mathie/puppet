class apt {
  package {
    'python-software-properties':
      ensure => present;
  }

  exec {
    'apt-get-update':
      command     => '/usr/bin/apt-get update',
      refreshonly => true,
  }
}
