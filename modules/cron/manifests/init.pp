class cron {
  include cron::install, cron::config, cron::service

  Class['cron::install'] -> Class['cron::config'] ~> Class['cron::service']
}
