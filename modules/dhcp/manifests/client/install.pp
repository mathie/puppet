class dhcp::client::install {
  package {
    'isc-dhcp-client':
      ensure => present;
  }
}
