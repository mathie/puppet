class gamevial::sites {
  include apache
  include apache::suexec
  include php::cgi

  class {
    'apache::fastcgi':
      suexec => true;
  }

  php::module {
    'mysql':
  }

  apache::module {
    'userdir':
  }

  mysql::server::database {
    'gamevial':
      password => '5hit3time2';

    'poogames':
      password => 'weewi';
  }

  gamevial::site {
      'poogames':
        apache_vhost_name => 'poogames.net',
        uid               => 10040;

      'gamevial':
        apache_vhost_name => 'gamevial.com',
        uid               => 10041;

      'teamtanks':
        apache_vhost_name => 'teamtanks.com',
        uid               => 10042;

      'flylikeabirdgame':
        apache_vhost_name => 'flylikeabirdgame.com',
        uid               => 10043;

      'namaball':
        apache_vhost_name => 'namaball.com',
        uid               => 10044;
  }
}
