class ci::dependencies::live_auction {
  include postgresql::server
  include redis::server
  include rabbitmq::server
  include phantomjs

  $rails_env   = 'development'


  postgresql::server::user {
    'jenkins':
      superuser => true;
  }

  rails::database {
    'live_auction_development':
      db_type     => 'postgresql',
      db_username => 'live_auction',
      rails_env   => $rails_env,
      order       => 1;

    'live_auction_test':
      db_type      => 'postgresql',
      db_username  => 'live_auction',
      rails_env    => $rails_env,
      stanza_title => 'test',
      order        => 2;
  }

  class {
    'live_auction::code':
      rails_env   => $rails_env;
  }
}
