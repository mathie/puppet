class openvpn::server {
  include openvpn::install, openvpn::server::config, openvpn::service
  Class['openvpn::install'] -> Class['openvpn::server::config'] ~> Class['openvpn::service']
}
