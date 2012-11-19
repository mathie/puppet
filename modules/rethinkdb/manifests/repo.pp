class rethinkdb::repo {
  apt::ppa {
    'rethinkdb':
      user => 'rethinkdb';
  }
}
