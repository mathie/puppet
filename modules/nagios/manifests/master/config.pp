class nagios::master::config {
  $nagios_admins = $::nagios::master::admins

  nginx::vhost {
    'nagios':
      content => template('nagios/nginx.conf.erb');
  }

  network::host_alias { 'nagios': }

  file {
    '/etc/nagios':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/etc/nagios3/cgi.cfg':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('nagios/cgi.cfg.erb');

    '/etc/nagios3/nagios.cfg':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('nagios/nagios.cfg.erb');

    '/var/lib/nagios3':
      owner => nagios,
      group => nagios,
      mode  => '0751';

    '/var/lib/nagios3/rw':
      owner => nagios,
      group => www-data,
      mode  => '2710';

    # Files that the Ubuntu package helpfully supplies that we don't need.
    '/etc/nagios3/conf.d/generic-host_nagios2.cfg':
      ensure => absent;

    '/etc/nagios3/conf.d/generic-service_nagios2.cfg':
      ensure => absent;

    '/etc/nagios3/conf.d/localhost_nagios2.cfg':
      ensure => absent;

    '/etc/nagios3/conf.d/extinfo_nagios2.cfg':
      ensure => absent;
  }

  @@concat::fragment {
    'nagios-nrpe-server-config':
      order   => '01',
      file    => 'nagios-nrpe-config',
      content => template('nagios/nrpe-server.cfg.erb');
  }

  include nagios::master::contacts,
    nagios::master::timeperiods,
    nagios::master::hosts,
    nagios::master::services

  anchor { 'nagios::master::config::begin': }
  anchor { 'nagios::master::config::end': }

  Anchor['nagios::master::config::begin'] -> Class['nagios::master::contacts']    -> Anchor['nagios::master::config::end']
  Anchor['nagios::master::config::begin'] -> Class['nagios::master::timeperiods'] -> Anchor['nagios::master::config::end']
  Anchor['nagios::master::config::begin'] -> Class['nagios::master::hosts']       -> Anchor['nagios::master::config::end']
  Anchor['nagios::master::config::begin'] -> Class['nagios::master::services']    -> Anchor['nagios::master::config::end']
}
