class ci::dependencies::my_ewgeco {
  include mysql::server
  include phantomjs

  # Need to install this as a system package because it depends upon
  # ruby_core_source which insists on writing to /usr/include/ruby-1.9.1.
  package {
    'perftools.rb':
      ensure   => present,
      provider => 'gem19';
  }

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
