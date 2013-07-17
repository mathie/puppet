class standard {
  include stages

  class {
    'apt':
      stage => first;

    'localisation':
      stage    => first,
      locale   => 'en_GB', # UTF-8 is automatically appended.
      timezone => 'GB-Eire';

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
    include collectd::agent

    class {
      'rsyslog::client':
        stage   => first,
        require => Class['network::hosts'];

      'openvpn::agent':
        stage   => first,
        require => Class['network::hosts'];
    }

    if $::vagrant == 'true' {
      class {
        'apt::cache::client':
          stage   => first,
          require => Class['openvpn::agent'];
      }
    }
  }

  include ntp::server
  include puppet::agent
  include mcollective::agent
  include cron
  include ssh::client, ssh::server
  include users
  include logrotate

  nagios::host { $::fqdn: }
  include nagios::nrpe_check::disk_space,
    nagios::nrpe_check::users,
    nagios::nrpe_check::processes,
    nagios::nrpe_check::load,
    nagios::nrpe_check::apt,
    nagios::nrpe_check::puppet,
    nagios::nrpe_check::swap,
    nagios::nrpe_check::memory

  users::account {
    'ubuntu':
      ensure => absent;
  }
}
