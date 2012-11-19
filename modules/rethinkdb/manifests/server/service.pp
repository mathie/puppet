class rethinkdb::server::service {
  service {
    'rethinkdb':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'rethinkdb-admin':
      port => '8080';

    'rethinkdb-intracluster':
      port => '29015';

    'rethinkdb-clients':
      port => '28015';
  }
}
