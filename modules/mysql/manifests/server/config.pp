class mysql::server::config {
  group {
    'mysql':
      ensure    => present,
      gid       => 10117,
      allowdupe => false;
  }

  user {
    'mysql':
      ensure    => present,
      uid       => 10110,
      gid       => 10117,
      comment   => 'MySQL Server',
      home      => '/nonexistant',
      shell     => '/bin/false',
      allowdupe => false,
      require   => Group['mysql'];
  }

  file {
    '/etc/mysql':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/etc/mysql/my.cnf':
      ensure => present,
      source => 'puppet:///modules/mysql/server/my.cnf',
      owner  => root,
      group  => root,
      mode   => '0644';

    '/var/lib/mysql':
      ensure  => directory,
      owner   => mysql,
      group   => mysql,
      mode    => '0660',
      recurse => true;
  }

  logrotate::log_file {
    'mysql-slow-query-log':
      log_file => '/var/lib/mysql/mysql-slow.log',
      days     => 28;
  }
}
