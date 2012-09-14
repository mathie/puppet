class graphite::install {
  group {
    'graphite':
      ensure    => present,
      gid       => 10120,
      allowdupe => false;
  }

  user {
    'graphite':
      ensure    => present,
      uid       => 10120,
      gid       => 10120,
      comment   => 'Graphite',
      home      => '/nonexistant',
      shell     => '/bin/false',
      allowdupe => false,
      require   => Group['graphite'];
  }

  file {
    '/opt/graphite':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    '/opt/graphite/storage':
      ensure  => directory,
      owner   => graphite,
      group   => graphite,
      recurse => true,
      mode    => '0644';

    '/opt/graphite/storage/rrd':
      ensure => directory,
      owner  => graphite,
      group  => graphite,
      mode   => '0755';

    '/opt/graphite/storage/rrd/collectd':
      ensure => directory,
      owner  => graphite,
      group  => graphite,
      mode   => '0755';
  }

  exec {
    'symlink-collectd-host-rrds':
      command => '/bin/bash -c \'cd /var/lib/collectd/rrd && for i in *; do ln -snf /var/lib/collectd/rrd/${i} /opt/graphite/storage/rrd/collectd/${i//./_}; done\'',
      user    => graphite,
      require => [ File['/var/lib/collectd/rrd'], File['/opt/graphite/storage/rrd/collectd'] ];
  }

  package {
    [ 'python-cairo', 'python-memcache', 'python-django',
      'python-django-tagging', 'python-twisted',
      'python-zope.interface', 'python-rrdtool', 'python-pip' ]:
      ensure => installed;

    [ 'whisper' ]:
      ensure   => installed,
      provider => 'pip',
      require  => Package['python-pip'];
  }

  # For some reason (probably because they install themselves in /opt), these
  # packages never register with pip as being installed, so get "reinstalled"
  # on every puppet run.
  exec {
    'pip-install-graphite-web':
      command => '/usr/bin/pip install graphite-web',
      creates => '/opt/graphite/webapp',
      require => Package['python-django'];

    'pip-install-carbon':
      command => '/usr/bin/pip install carbon',
      creates => '/opt/graphite/lib/carbon',
      require => Package['python-twisted'];
  }

  apt::repository {
    'gunicorn':
      source => 'puppet:///modules/graphite/gunicorn-sources.list';
  }

  apt::key {
    'gunicorn-public-key':
      keyid => '5370FF2A';
  }

  package {
    'gunicorn':
      ensure => present;
  }

  Apt::Repository['gunicorn'] -> Apt::Key['gunicorn-public-key'] -> Exec['apt-get-update'] -> Package['gunicorn']
}
