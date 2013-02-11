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

  rails::database {
    'my_ewgeco_development':
      app       => 'my_ewgeco',
      rails_env => 'development',
      username  => 'root',
      db_type   => 'mysql2',
      order     => 1;

    'my_ewgeco_test':
      app          => 'my_ewgeco',
      rails_env    => 'development',
      stanza_title => 'test',
      username     => 'root',
      db_type      => 'mysql2',
      order        => 2;
  }

  class {
    'my_ewgeco::code':
      rails_env   => 'development';
  }
}
