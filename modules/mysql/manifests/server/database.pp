define mysql::server::database($user = $name, $password = undef, $grant = true) {
  $database_name = $name

  $password_flag = $password ? {
    undef   => '',
    default => " -p${password}",
  }

  $password_sql_fragment = $password ? {
    undef   => '',
    default => " IDENTIFIED BY '${password}'",
  }

  sql {
    "mysql-create-${database_name}":
      sql    => "CREATE DATABASE ${database_name};",
      unless => "/usr/bin/mysql -uroot${mysql::server::root_password_flag} ${database_name} -e 'select 1'";
  }

  if $grant {
    sql {
      "mysql-grant-${user}-on-${database_name}":
        sql    => "GRANT ALL ON ${database_name}.* TO ${user}@'%'${password_sql_fragment}; GRANT ALL ON ${database_name}.* TO ${user}@'localhost'${password_sql_fragment};",
        unless => "/usr/bin/mysqlshow -u${user}${password_flag} ${database_name}";
    }
  }
}
