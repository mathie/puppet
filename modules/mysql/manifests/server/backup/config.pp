class mysql::server::backup::config {
  $backup_username = 'root'
  $backup_password = $mysql::server::root_password

  $aws_access_key        = $mysql::server::backup::aws_access_key
  $aws_access_key_secret = $mysql::server::backup::aws_access_key_secret
  $aws_bucket            = $mysql::server::backup::aws_bucket

  File {
    owner => root,
    group => root,
    mode  => '0600',
  }

  file {
    '/var/backups/mysql':
      ensure => directory;

    '/var/backups/mysql/full':
      ensure => directory;

    '/var/backups/mysql/differential':
      ensure => directory;

    '/var/backups/mysql/tmp':
      ensure => directory;

    '/etc/default/mysql-server-backup':
      ensure  => present,
      content => template('mysql/server/backup/etc-default-mysql-server-backup.erb');

    '/etc/s3cmd.cfg':
      ensure  => present,
      content => template('mysql/server/backup/s3cmd.cfg.erb');

    '/usr/sbin/mysql-backup':
      ensure => present,
      source => 'puppet:///modules/mysql/server/mysql-backup.sh',
      mode   => '0755';

    '/usr/sbin/mysql-restore':
      ensure => present,
      source => 'puppet:///modules/mysql/server/mysql-restore.sh',
      mode   => '0755';
  }

  cron {
    'mysql-backup-full':
      command => '/usr/sbin/mysql-backup full >> /var/log/mysql/full-backup.log 2>&1',
      hour    => [ 0, 4, 8, 12, 16, 20 ],
      minute  => 0,
      user    => root;

    'mysql-backup-differential':
      command => '/usr/sbin/mysql-backup differential >> /var/log/mysql/differential-backup.log 2>&1',
      minute  => [ 10, 20, 30, 40, 50 ],
      user    => root;
  }

  logrotate::log_file {
    'mysql-backup-full':
      log_file => '/var/log/mysql/full-backup.log';

    'mysql-backup-differential':
      log_file => '/var/log/mysql/differential-backup.log';
  }
}
