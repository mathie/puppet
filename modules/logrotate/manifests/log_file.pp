define logrotate::log_file($log_file, $days = 28) {
  file {
    "/etc/logrotate.d/${name}":
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('logrotate/log_file_config.erb');
  }
}
