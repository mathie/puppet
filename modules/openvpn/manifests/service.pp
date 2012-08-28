class openvpn::service {
  service {
    'openvpn':
      ensure    => running,
      hasstatus => false, # Just plain irritating, apparently.
      enable    => true;
  }

  firewall::allow {
    'openvpn-tcp':
      port => '1194';

    'openvpn-udp':
      proto => 'udp',
      port  => '1194';
  }
}
