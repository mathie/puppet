define mysql::server::sql($sql, $user = 'root', $password = undef, $unless = undef) {
  if $password {
    $password_arg = "-p${password}"
  } else {
    $password_arg = ''
  }

  exec {
    "mysql-sql-${name}":
      command => "/usr/bin/mysql -u${user}${password_arg} -e \"${sql}\"",
      unless  => $unless,
      require => Class['mysql::server::service'];
  }
}
