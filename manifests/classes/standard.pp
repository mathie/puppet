class standard {
  stage {
    'first':
      before => Stage['main'];

    'last':
      require => Stage['main'];
  }

  class {
    'network::hosts':
      stage => first;

    'firewall':
      stage => first;
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
  include postfix

  class {
    'newrelic::agent':
      license_key => '8994aa98999cb87e80a8a988d3320cc7078700ff';
  }
}
