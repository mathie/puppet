define mysql::server::database($user = $name, $password = undef) {
  $password_flag = $password ? {
    undef   => '',
    default => " -p${password}",
  }

  $password_sql_fragment = $password ? {
    undef   => '',
    default => " IDENTIFIED BY '${password}'",
  }

  sql {
    "mysql-create-${name}":
      sql    => "CREATE DATABASE ${name};",
      unless => "/usr/bin/mysql -uroot${mysql::server::root_password_flag} ${name} -e 'select 1'";

    "mysql-grant-${name}":
      sql    => "GRANT ALL ON ${name}.* TO ${user}@'%'${password_sql_fragment}; GRANT ALL ON ${name}.* TO ${user}@'localhost'${password_sql_fragment};",
      unless => "/usr/bin/mysqlshow -u${user}${password_flag} ${name}";
  }
}
