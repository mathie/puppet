class standard {
  if $::hostname != 'puppet' {
    include openvpn::agent
    include rsyslog::client
    include collectd::agent

    # Prefer OpenVPN to be running before setting up the hosts file so we use
    # the VPN IP.
    Class['openvpn::agent'] -> Class['network::hosts']
  }

  include ntp::server
  include puppet::agent
  include mcollective::agent
  include cron
  include ssh::client, ssh::server
  include users
  include network::hosts
  include firewall

  class {
    'newrelic::agent':
      license_key => '8994aa98999cb87e80a8a988d3320cc7078700ff';
  }
}
