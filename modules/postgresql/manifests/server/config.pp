class postgresql::server::config {
  exec {
    'postgresql-drop-cluster':
      command => '/usr/bin/pg_dropcluster --stop 9.1 main',
      onlyif  => "/usr/bin/psql -c '\\l+' |awk '/template0/ { print \$5 }' |grep 'SQL_ASCII'",
      user    => postgres,
      notify  => Exec['postgresql-create-cluster'];

    'postgresql-create-cluster':
      command     => '/usr/bin/pg_createcluster --locale=en_GB.UTF-8 9.1 main',
      user        => postgres,
      refreshonly => true,
      before      => [ File['/etc/postgresql/9.1/main/postgresql.conf'], File['/etc/postgresql/9.1/main/pg_hba.conf'] ];
  }

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
