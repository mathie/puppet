class openvpn::install {
  package {
    'openvpn':
      ensure => present,
  }
}
