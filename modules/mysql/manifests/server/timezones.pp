class mysql::server::timezones {
  if $mysql::server::root_password {
    $password_arg = " -p${mysql::server::root_password}"
  } else {
    $password_arg = ''
  }

  exec {
    'mysql-import-timezones':
      command => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | /usr/bin/mysql -uroot${password_arg} mysql",
      unless  => "/usr/bin/mysql -uroot${password_arg} -e 'SELECT * FROM time_zone_name' mysql | /bin/grep 'Etc/UTC'",
      require => Class['mysql::server'];
  }
}
