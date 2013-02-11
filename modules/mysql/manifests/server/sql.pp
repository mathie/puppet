define mysql::server::sql(
  $sql,
  $user     = 'root',
  $password = $mysql::server::root_password,
  $database = 'mysql',
  $unless   = undef
) {
  if $password and $password != '' {
    $password_arg = " -p${password}"
  } else {
    $password_arg = ''
  }

  exec {
    "mysql-sql-${name}":
      command => "/usr/bin/mysql -u${user}${password_arg} -e \"${sql}\" ${database}",
      unless  => $unless,
      require => Class['mysql::server::service'];
  }
}
