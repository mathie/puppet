class openvpn::service {
  service {
    'openvpn':
      ensure     => running,
      hasrestart => true,
      hasstatus  => false, # Just plain irritating, apparently.
      enable     => true,
  }
}
