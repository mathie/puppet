class apt::cache::server::config {
  @@file {
    '/etc/apt/apt.conf.d/50proxy':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      tag     => 'apt-cache-client',
      content => template('apt/proxy.conf.erb');
  }
}
