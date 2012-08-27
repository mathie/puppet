class mcollective::agent::config {
  file {
    '/etc/mcollective/server.cfg':
      ensure  => present,
      content => template('mcollective/server.cfg.erb'),
      owner   => root,
      group   => root,
      mode    => '0600',
  }
}
