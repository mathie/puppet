class openvpn::agent::config {
  file {
    '/etc/openvpn/agent.conf':
      ensure  => present,
      content => template('openvpn/agent.conf.erb'),
      require => Host["vpnmaster.${::domain}"];
  }
}
