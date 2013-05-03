class mysql::deadlocks::config {
  $root_password_flag = $mysql::server::root_password_flag

  mysql::server::database {
    $mysql::deadlocks::database:
      password => $mysql::deadlocks::password;
  }

  file {
    '/etc/init/pt-deadlock-logger.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('mysql/upstart-pt-deadlock-logger.conf.erb');
  }
}
