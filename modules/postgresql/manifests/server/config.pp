class postgresql::server::config {
  file {
    '/etc/postgresql/9.1/main/postgresql.conf':
      ensure  => present,
      owner   => postgres,
      group   => postgres,
      mode    => '0644',
      content => template('postgresql/postgresql.conf.erb');

    '/etc/postgresql/9.1/main/pg_hba.conf':
      ensure  => present,
      owner   => postgres,
      group   => postgres,
      mode    => '0600',
      content => template('postgresql/pg_hba.conf.erb');
  }
}
