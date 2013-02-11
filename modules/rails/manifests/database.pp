define rails::database(
  $db_type,
  $app          = $name,
  $database     = $name,
  $hostname     = $::hostname,
  $username     = $name,
  $password     = '',
  $rails_env    = 'production',
  $stanza_title = $rails_env,
  $order        = 50
) {

  if $db_type == 'mysql' or $db_type == 'mysql2' {
    mysql::server::database {
      $database:
        user     => $username,
        password => $password;
    }
  } elsif $db_type == 'postgresql' {
    postgresql::server::user {
      $username:
        password => $password;
    }

    postgresql::server::database {
      $database:
        owner => $username;
    }
  } else {
    fail "Unknown database type: ${db_type}"
  }

  @@rails::database::stanza {
    "${app}_${rails_env}_${database}":
      stanza_title => $stanza_title,
      db_type      => $db_type,
      app          => $app,
      database     => $database,
      hostname     => $hostname,
      username     => $username,
      password     => $password,
      rails_env    => $rails_env,
      order        => $order;
  }
}
