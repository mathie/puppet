class openvpn::agent::config {
  file {
    '/etc/openvpn/agent.conf':
      ensure  => present,
      content => template('openvpn/agent.conf.erb'),
  }

  include openvpn::firewall

  Class['openvpn::firewall'] -> Class['openvpn::service']
}
