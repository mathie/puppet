class digi::config {
  $digi_username = $digi::username
  $digi_password = $digi::password
  $cache_file    = $digi::cache_file
  $display_files = $digi::display_files

  file {
    '/etc/default/digi-poller':
      ensure  => present,
      owner   => digi,
      group   => digi,
      mode    => '0600',
      content => template('digi/etc-default-digi-poller.erb');

    '/usr/bin/digi-poller':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0755',
      source => 'puppet:///modules/digi/digi-poller.sh';
  }

  cron {
    'digi-poller':
      command => '/usr/bin/digi-poller >> /u/apps/digi/current/log/poller.log 2>&1',
      user    => digi,
      minute  => 10;
  }
}
