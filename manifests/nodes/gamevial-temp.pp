node /^gamevial/ {
  include standard

  class {
    'postfix::smtp_auth':
      mail_domain => 'gamevial.com',
      destination => 'gamevial.com',
      root_email  => 'pete@gamevial.com';
  }

  postfix::virtual_domain {
    [
      'teamtanks.com',
      'poogames.net',
      'flylikeabirdgame.com',
      'namaball.com'
    ]:
  }

  postfix::virtual {
    [
      # gamevial.com
      'abuse@gamevial.com',
      'hostmaster@gamevial.com',
      'postmaster@gamevial.com',
      'webmaster@gamevial.com',
      'gamevial@gamevial.com',

      # poogames.net
      'abuse@poogames.net',
      'hostmaster@poogames.net',
      'postmaster@poogames.net',
      'webmaster@poogames.net',
      'poogames@poogames.net',

      # teamtanks.com
      'abuse@teamtanks.com',
      'hostmaster@teamtanks.com',
      'postmaster@teamtanks.com',
      'webmaster@teamtanks.com',
      'teamtanks@teamtanks.com',

      # flylikeabirdgame.com
      'abuse@flylikeabirdgame.com',
      'hostmaster@flylikeabirdgame.com',
      'postmaster@flylikeabirdgame.com',
      'webmaster@flylikeabirdgame.com',
      'flylikeabirdgame@flylikeabirdgame.com',

      # namaball.com
      'abuse@namaball.com',
      'hostmaster@namaball.com',
      'postmaster@namaball.com',
      'webmaster@namaball.com',
      'namaball@namaball.com',
    ]:
      destination => 'pete@gamevial.com';

    'pete@gamevial.com':
      destination => 'pete.gamevial';

    'james@gamevial.com':
      destination => 'james.gamevial';

    'mathie@gamevial.com':
      destination => 'mathie';
  }

  users::account {
    'pete.gamevial':
      uid      => 10011,
      password => '$6$50491979$ViS0qCiIPsxhqOI4SUgElbUyoF.cjuR/o5vY/R826xMR90uqBYybnHTj1RECc1rHv7GbDtZKtbz.EWYslvUkJ.',
      comment  => 'Peter Roobol';

    'james.gamevial':
      uid      => 10012,
      password => '$6$50492016$Q1SKQHNTPepeUnAzLpCgjZafPgVYLmBov1AUBMLV5.V3LHA91AAtbAjKebrFEIm5D5QF4nWjNnPlU6FBgA.4W0',
      comment  => 'James Flowerdew';
  }

  class {
    'mysql::server':
      root_password => 'Eepeew4iEsohx9ou';
  }

  include dovecot::pop3

  include gamevial::sites
}
