define mysql::server::database($user, $password) {
  sql {
    "mysql-create-${name}":
      sql    => "CREATE DATABASE ${name};",
      unless => "/usr/bin/mysql -uroot ${name} -e 'select 1'";

    "mysql-grant-${name}":
      sql    => "GRANT ALL ON ${name}.* TO ${user}@'%' IDENTIFIED BY '${password}'; GRANT ALL ON ${name}.* TO ${user}@'localhost' IDENTIFIED BY '${password}';",
      unless => "/usr/bin/mysqlshow -u${user} -p${password} ${name}";
  }
}
