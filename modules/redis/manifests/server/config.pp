class redis::server::config {
  file {
    '/etc/redis/redis.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('redis/redis.conf.erb');
  }
}
