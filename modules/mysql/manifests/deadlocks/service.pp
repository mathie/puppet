class mysql::deadlocks::service {
  service {
    'pt-deadlock-logger':
      ensure => running,
      enable => true;
  }

  mysql::server::nrpe_check {
    'deadlocks':
      description => 'MySQL deadlocks';
  }
}
