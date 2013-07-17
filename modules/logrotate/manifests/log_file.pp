define logrotate::log_file(
  $log_file,
  $frequency  = 'weekly',
  $keep       = 52,
  $owner      = undef,
  $group      = undef,
  $mode       = undef,
  $prerotate  = undef,
  $postrotate = undef
) {
  file {
    "/etc/logrotate.d/${name}":
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('logrotate/log_file_config.erb');
  }
}
