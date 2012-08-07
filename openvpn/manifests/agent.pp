class openvpn::agent {
  include openvpn::install, openvpn::agent::config, openvpn::service
  Class['openvpn::install'] -> Class['openvpn::agent::config'] ~> Class['openvpn::service']
}
