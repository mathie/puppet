class rethinkdb::server::install {
  include rethinkdb::repo

  package {
    'rethinkdb':
      ensure => present;
  }

  Class['rethinkdb::repo'] -> Package['rethinkdb']
}
