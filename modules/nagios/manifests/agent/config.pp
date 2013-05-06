class nagios::agent::config {
  nginx::user {
    $nagios::agent::htpasswd_user:
      password => $nagios::agent::htpasswd_password;
  }

  file {
    '/etc/nagios/nrpe_local.cfg':
      ensure => absent;

    '/etc/nagios/nrpe.d':
      ensure  => absent,
      force   => true,
      recurse => true;
  }

  concat::file {
    'nagios-nrpe-config':
      path  => '/etc/nagios/nrpe.cfg',
      owner => root,
      group => root,
      mode  => '0644';
  }

  concat::fragment {
    'nagios-nrpe-base-config':
      order   => '01',
      file    => 'nagios-nrpe-config',
      content => template('nagios/nrpe-base.cfg.erb');
  }

  Concat::Fragment <<| file == 'nagios-nrpe-config' |>>
}
