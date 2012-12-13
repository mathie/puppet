node /^staging-ewgeco/ {
  include standard
  include redis::server
  include mysql::server
  include memcached::server

  mysql::server::database {
    'my_ewgeco':
      user     => 'my_ewgeco',
      password => 'seetu2UP';
  }

  class {
    'my_ewgeco::code':
      rails_env   => 'staging',
      database    => 'my_ewgeco',
      db_host     => 'localhost',
      db_username => 'my_ewgeco',
      db_password => 'seetu2UP';

    'my_ewgeco::app_server':
      rails_env => 'staging';

    'my_ewgeco::worker':
      rails_env => 'staging';
  }
}
