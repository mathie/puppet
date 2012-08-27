class openvpn::service {
  service {
    'openvpn':
      ensure    => running,
      hasstatus => false, # Just plain irritating, apparently.
      enable    => true;
  }
}
