class ci::dependencies::my_ewgeco {
  include mysql::server

  mysql::server::database {
    'my_ewgeco_development':
      user     => 'root',
      password => '';

    'my_ewgeco_test':
      user     => 'root',
      password => '';
  }

  class {
    'my_ewgeco::code':
      database    => 'my_ewgeco_development',
      db_host     => 'localhost',
      db_username => 'root',
      db_password => '',
      rails_env   => 'development';
  }
}
