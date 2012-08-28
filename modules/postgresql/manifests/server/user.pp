define postgresql::server::user($password) {
  exec {
    "postgresql-user-${name}":
      command => "/usr/bin/psql -c \"CREATE ROLE ${name} UNENCRYPTED PASSWORD '${password}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"",
      unless  => "/usr/bin/psql -c '\du'| /bin/grep -q ${name}",
      user    => 'postgres',
      require => Class['postgresql::server'];
  }
}
