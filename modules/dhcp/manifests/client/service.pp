class dhcp::client::service {
  exec {
    "restart-network-interface-${dhcp::client::interface}":
      refreshonly => true,
      command     => "/usr/sbin/service network-interface restart INTERFACE=${dhcp::client::interface}";
  }
}
