class memcached::server::config {
  file {
    '/etc/memcached.conf':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/memcached/memcached.conf';
  }
}
