class mysql::server::checks {
  mysql::server::nrpe_check {
    'deleted-files':
      description => 'MySQL check for deleted files',
      sudo        => true;

    'file-privs':
      description => 'MySQL check file privileges',
      sudo        => true;

    'processlist':
      description => 'MySQL Process list';

    'pidfile':
      description => 'MySQL PID file present',
      sudo        => true;
  }

  mysql::server::nrpe_check_innodb {
    'idle-blocker-duration':
      description => 'MySQL idle blocking transaction';

    'waiter-count':
      description => 'MySQL InnoDB waiter count';

    'max-duration':
      description => 'MySQL InnoDB max duration';
  }

  mysql::server::nrpe_check_status_percent {
    'connections':
      description => 'MySQL current connections',
      current     => 'Threads_connected',
      total       => 'max_connections',
      warning     => 50,
      critical    => 80;
  }
}
