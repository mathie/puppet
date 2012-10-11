class logrotate {
  include logrotate::install, logrotate::config

  Class['logrotate::install'] -> Class['logrotate::config']
}
