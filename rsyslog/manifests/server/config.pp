class rsyslog::server::config {
  file {
    '/etc/rsyslog.conf':
      content => template('rsyslog/server/rsyslog.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644';
  }
}
