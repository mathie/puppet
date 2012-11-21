define postgresql::server::user($password = undef, $superuser = false) {
  include postgresql::client, postgresql::server

  $password_string = $password ? {
    undef   => '',
    default => "UNENCRYPTED PASSWORD '${password}'",
  }

  $permissions_string = $superuser ? {
    true    => 'SUPERUSER CREATEDB CREATEROLE',
    default => 'NOSUPERUSER NOCREATEDB NOCREATEROLE',
  }

  exec {
    "postgresql-user-${name}":
      command => "/usr/bin/psql -c \"CREATE ROLE ${name} ${password_string} ${permissions_string} INHERIT LOGIN;\"",
      unless  => "/usr/bin/psql -c '\\du'| /bin/grep -q ${name}",
      user    => 'postgres';
  }

  Class['postgresql::client'] -> Exec["postgresql-user-${name}"]
  Class['postgresql::server::service'] -> Exec["postgresql-user-${name}"]
}
