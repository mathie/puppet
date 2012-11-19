class rethinkdb::server($coordinator) {
  include rethinkdb::server::install, rethinkdb::server::service, rethinkdb::server::cluster_config

  class {
    'rethinkdb::server::config':
      coordinator => $coordinator;
  }

  Class['rethinkdb::server::install'] -> Class['rethinkdb::server::config'] ~> Class['rethinkdb::server::service'] -> Class['rethinkdb::server::cluster_config']
}
