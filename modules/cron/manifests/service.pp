class cron::service {
  service {
    'cron':
      ensure => running,
      enable => true;
  }
}
