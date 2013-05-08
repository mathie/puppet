class puppet::dashboard::config {
  $database = 'dashboard'
  $db_username = $database
  $db_password = 'aiquayeequaeshus'

  mysql::server::database {
    $database:
      user     => $db_username,
      password => $db_password;
  }

  concat::fragment {
    'puppet-conf-dashboard':
      file    => 'puppet.conf',
      content => template('puppet/puppet-dashboard.conf.erb');
  }

  file {
    '/etc/puppet-dashboard/database.yml':
      ensure  => present,
      owner   => www-data,
      group   => www-data,
      mode    => '0640',
      content => template('puppet/dashboard/database.yml.erb');

    '/etc/default/puppet-dashboard':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('puppet/dashboard/etc-default-puppet-dashboard.erb');

    '/etc/default/puppet-dashboard-workers':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('puppet/dashboard/etc-default-puppet-dashboard-workers.erb');

    '/etc/init.d/puppet-dashboard':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('puppet/dashboard/puppet-dashboard-init.erb');
  }

  exec {
    'create-puppet-dashboard-schema':
      command     => '/usr/bin/rake db:migrate',
      cwd         => '/usr/share/puppet-dashboard',
      environment => [ 'RAILS_ENV=production', 'HOME=/' ],
      refreshonly => true,
      require     => [ Mysql::Server::Database[$database], File['/etc/puppet-dashboard/database.yml'] ];
  }

  Mysql::Server::Database[$database] ~> Exec['create-puppet-dashboard-schema']

  nginx::vhost_to_local_upstream {
    'puppet-dashboard':
      upstream_port        => 3000,
      aliases              => [ 'puppet' ],
      root                 => '/usr/share/puppet-dashboard',
      additional_port      => 8084,
      remote_auth_required => true;
  }

  cron {
    'puppet-dashboard-report-cleanup':
      command     => 'cd /usr/share/puppet-dashboard && /usr/bin/ruby1.8 -S rake reports:prune upto=1 unit=mon >> /usr/share/puppet-dashboard/log/cron.log 2>&1',
      user        => www-data,
      monthday    => 11,
      hour        => 3,
      minute      => 15,
      environment => [
        'RAILS_ENV=production',
        'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
      ];

    'puppet-dashboard-db-optimize':
      command     => 'cd /usr/share/puppet-dashboard && /usr/bin/ruby1.8 -S rake db:raw:optimize >> /usr/share/puppet-dashboard/log/cron.log 2>&1',
      user        => www-data,
      monthday    => 12,
      hour        => 3,
      minute      => 15,
      environment => [
        'RAILS_ENV=production',
        'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
      ];
  }

  logrotate::log_file {
    'puppet-dashboard':
      log_file => '/usr/share/puppet-dashboard/log/*.log',
      days     => 28;
  }
}
