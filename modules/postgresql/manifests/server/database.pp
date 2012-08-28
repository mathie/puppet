define postgresql::server::database($owner) {
  exec {
    "postgresql-database-${name}":
      command => "/usr/bin/createdb -O ${owner} ${name}",
      unless  => "/usr/bin/psql -l | /bin/grep -q ${name}",
      user    => 'postgres',
      require => [ Class['postgresql::server'], Postgresql::Server::User[$owner] ];
  }
}
