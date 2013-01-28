class dhcp::client::config {
  file {
    '/etc/dhcp/dhclient.conf':
      ensure  => present,
      content => template('dhcp/client/dhclient.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644';
  }
}
