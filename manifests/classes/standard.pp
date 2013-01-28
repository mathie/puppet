class standard {
  include bootstrap_common

  class {
    'dhcp::client':
      stage     => first,
      interface => 'eth0';

    'network::hosts':
      stage => first;

    'firewall':
      enabled => false,
      stage   => first;
  }

  if $::hostname != 'puppet' {
    class {
      'rsyslog::client':
        stage   => first,
        require => Class['network::hosts'];

      'openvpn::agent':
        stage   => first,
        require => Class['network::hosts'];
    }

    include collectd::agent
  }

  include ntp::server
  include puppet::agent
  include mcollective::agent
  include cron
  include ssh::client, ssh::server
  include users
  include logrotate
  include apt::unattended_upgrades
}
