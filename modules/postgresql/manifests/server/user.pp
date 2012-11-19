define postgresql::server::user($password) {
  include postgresql::client, postgresql::server

  exec {
    "postgresql-user-${name}":
      command => "/usr/bin/psql -c \"CREATE ROLE ${name} UNENCRYPTED PASSWORD '${password}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\"",
      unless  => "/usr/bin/psql -c '\\du'| /bin/grep -q ${name}",
      user    => 'postgres';
  }

  Class['postgresql::client'] -> Exec["postgresql-user-${name}"]
  Class['postgresql::server'] -> Exec["postgresql-user-${name}"]
}
