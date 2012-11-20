class ci::dependencies::live_auction {
  include postgresql::server

  $db_host     = 'localhost'
  $database    = 'live_auction_development'
  $db_username = 'live_auction'
  $db_password = ''
  $rails_env   = 'development'


  postgresql::server::user {
    $db_username:
      password => $db_password;
  }

  postgresql::server::database {
    $database:
      owner => $db_username;

    'live_auction_test':
      owner => $db_username;
  }

  class {
    'live_auction::code':
      rails_env   => $rails_env,
      database    => $database,
      db_host     => $db_host,
      db_username => $db_username,
      db_password => $db_password;
  }
}
