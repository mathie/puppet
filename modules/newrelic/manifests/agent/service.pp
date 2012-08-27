class newrelic::agent::service {
  service {
    'newrelic-sysmond':
      ensure => running,
      enable => true;
  }
}
