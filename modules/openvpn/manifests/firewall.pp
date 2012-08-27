class openvpn::firewall {
  include firewall

  firewall::allow {
    'openvpn-udp':
      proto => 'udp',
      port  => '1194';
  }
}
