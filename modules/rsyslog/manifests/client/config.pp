class rsyslog::client::config {
  file {
    '/etc/rsyslog.conf':
      content => template('rsyslog/client/rsyslog.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0644';
  }
}
