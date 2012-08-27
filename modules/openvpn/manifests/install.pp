class openvpn::install {
  package {
    'openvpn':
      ensure => present,
  }

  file {
    '/dev/net':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  exec {
    'create /dev/net/tun':
      command => '/bin/mknod -m 0666 /dev/net/tun c 10 200',
      creates => '/dev/net/tun',
      require => File['/dev/net'];
  }
}
