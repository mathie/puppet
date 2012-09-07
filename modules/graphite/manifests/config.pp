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

    '/opt/graphite/conf/carbon.conf':
      ensure  => present,
      content => template('graphite/carbon.conf.erb');

    '/opt/graphite/conf/storage-schemas.conf':
      ensure  => present,
      content => template('graphite/storage-schemas.conf.erb');
  }
}
