class crtmpserver::config {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/etc/crtmpserver':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/crtmpserver/conf.d':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/crtmpserver/applications':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/crtmpserver/crtmpserver.lua':
      ensure => present,
      source => 'puppet:///modules/crtmpserver/crtmpserver.lua';

    '/etc/crtmpserver/log_appenders.lua':
      ensure => present,
      source => 'puppet:///modules/crtmpserver/log_appenders.lua';

    '/etc/crtmpserver/enabled_applications.conf':
      ensure => present,
      source => 'puppet:///modules/crtmpserver/enabled_applications.conf';

    '/etc/crtmpserver/applications/flvplayback.lua':
      ensure => present,
      source => 'puppet:///modules/crtmpserver/flvplayback.lua';

    '/etc/crtmpserver/conf.d/users.lua':
      ensure => present,
      source => 'puppet:///modules/crtmpserver/users.lua';
  }
}
