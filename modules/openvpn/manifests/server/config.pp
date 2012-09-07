class openvpn::server::config {
  file {
    '/etc/openvpn/server.conf':
      ensure  => present,
      content => template('openvpn/server.conf.erb');

    '/etc/openvpn/dh1024.pem':
      ensure => present,
      source => 'puppet:///modules/openvpn/dh1024.pem';
  }

  @@host {
    "vpnmaster.${::domain}":
      ensure       => present,
      ip           => $::ipaddress_internal,
      host_aliases => [ 'vpnmaster' ];
  }
}
