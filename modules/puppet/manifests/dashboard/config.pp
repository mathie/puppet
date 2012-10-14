class puppet::dashboard::config {
  $database = 'dashboard'
  $db_username = $database
  $db_password = 'aiquayeequaeshus'

  mysql::server::database {
    $database:
      user     => $db_username,
      password => $db_password;
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

  nginx::upstream {
    'puppet_dashboard':
  }

  @@nginx::upstream::server {
    'puppet_dashboard_localhost_production':
      upstream => 'puppet_dashboard',
      target   => '127.0.0.1:3000',
      options  => 'fail_timeout=0';
  }

  nginx::vhost {
    'puppet-dashboard':
      content => template('puppet/dashboard/nginx.conf.erb');
  }
}
