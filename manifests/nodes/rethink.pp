node /^rethink/ {
  include standard

  class {
    'rethinkdb::server':
      coordinator => 'rethink01';
  }
}
