class dhcp::client::config {
  file {
    '/etc/dhcp/dhclient.conf':
      ensure  => present,
      content => template('dhcp/client/dhclient.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644';

    '/etc/dhcp/dhclient-enter-hooks.d':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/etc/dhcp/dhclient-enter-hooks.d/resolvconf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dhcp/client/resolvconf.sh.erb');
  }
}
