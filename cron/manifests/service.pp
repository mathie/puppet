class cron::service {
  service {
    'cron':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true;
  }
}
