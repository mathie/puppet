class mysql::server::config {
  group {
    'mysql':
      ensure    => present,
      gid       => 117,
      allowdupe => false;
  }

  user {
    'mysql':
      ensure    => present,
      uid       => 110,
      gid       => 117,
      comment   => 'MySQL Server',
      home      => '/nonexistant',
      shell     => '/bin/false',
      allowdupe => false,
      require   => Group['mysql'];
  }

  File {
    owner   => mysql,
    group   => mysql,
    require => [ Group['mysql'], User['mysql'] ],
  }

  file {
    '/etc/mysql':
      ensure => directory,
      mode   => '0755';

    '/etc/mysql/my.cnf':
      ensure => present,
      source => 'puppet:///modules/mysql/server/my.cnf',
      mode   => '0644';
  }
}
