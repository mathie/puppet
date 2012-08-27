class openvpn::server::config {
  file {
    '/etc/openvpn/server.conf':
      ensure  => present,
      content => template('openvpn/server.conf.erb');

    '/etc/openvpn/dh1024.pem':
      ensure => present,
      source => 'puppet:///modules/openvpn/dh1024.pem';
  }

  firewall::allow {
    'openvpn-tcp':
      port => '1194';
  }

  include openvpn::firewall

  Class['openvpn::firewall'] -> Class['openvpn::service']
}
