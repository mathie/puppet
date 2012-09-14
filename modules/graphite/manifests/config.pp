class graphite::config {
  File {
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  file {
    '/etc/init/carbon-cache.conf':
      ensure  => present,
      content => template('graphite/carbon-cache-upstart.conf.erb');

    '/etc/init/graphite-web.conf':
      ensure  => present,
      content => template('graphite/graphite-web-upstart.conf.erb');

    '/opt/graphite/conf/carbon.conf':
      ensure  => present,
      content => template('graphite/carbon.conf.erb');

    '/opt/graphite/conf/storage-schemas.conf':
      ensure  => present,
      content => template('graphite/storage-schemas.conf.erb');

    '/opt/graphite/webapp/graphite/local_settings.py':
      ensure  => present,
      content => template('graphite/local_settings.py.erb');
  }

  exec {
    'graphite-syncdb':
      command => '/usr/bin/python /opt/graphite/webapp/graphite/manage.py syncdb --noinput',
      creates => '/opt/graphite/storage/graphite.db',
      user    => graphite,
      require => File['/opt/graphite/webapp/graphite/local_settings.py'];
  }

  nginx::upstream {
    'graphite_web':
  }

  @@nginx::upstream::server {
    'graphite-web-localhost':
      upstream => 'graphite_web',
      target   => '127.0.0.1:8181',
      options  => 'fail_timeout=0';
  }

  nginx::vhost {
    'graphite-web':
      content => template('graphite/nginx-vhost.conf.erb');
  }
}
