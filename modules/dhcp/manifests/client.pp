class dhcp::client($interface = 'eth0') {
  include dhcp::client::install, dhcp::client::config, dhcp::client::service

  Class['dhcp::client::install'] -> Class['dhcp::client::config'] ~> Class['dhcp::client::service']
}
