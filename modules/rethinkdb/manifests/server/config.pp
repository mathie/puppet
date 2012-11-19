class rethinkdb::server::config($coordinator) {
  file {
    '/etc/rethinkdb/instances.d/default.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('rethinkdb/default.conf.erb');
  }

  exec {
    'rethinkdb-initialize-default-db':
      command => "/usr/bin/rethinkdb create -d /var/lib/rethinkdb/instances.d/default -n ${::hostname}",
      creates => '/var/lib/rethinkdb/instances.d/default',
      require => File['/etc/rethinkdb/instances.d/default.conf'];
  }
}
