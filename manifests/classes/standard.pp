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
    class {
      'rsyslog::client':
        stage   => first,
        require => Class['network::hosts'];

      'openvpn::agent':
        stage   => first,
        require => Class['network::hosts'];

      'apt::cache::client':
        stage   => first,
        require => Class['openvpn::agent'];
    }

    include collectd::agent
  }

  include ntp::server
  include puppet::agent
  include mcollective::agent
  include cron
  include ssh::client, ssh::server
  include logrotate
  include apt::unattended_upgrades

  include users
  users::account {
    'ubuntu':
      ensure => absent;

    'mathie':
      uid      => 10001,
      password => '$6$sIQnqvVz$LOocGXi65myfyIne7knOr0KL0QkjReLbuSe9Fe5ct.jGOVTWf6NID4toF6Pkm5I5nRldC4CtcC.kyLo6ddZKQ0',
      htpasswd => '$apr1$z7n8mzjB$rNsr7NhLnqPDnR.Pd20zz0',
      comment  => 'Graeme Mathieson',
      email    => 'mathie@rubaidh.com',
      sudo     => true;
  }
}
