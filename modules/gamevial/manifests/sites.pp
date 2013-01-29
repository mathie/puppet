class gamevial::sites {
  include apache
  include apache::php_fcgid

  php::module {
    'mysql':
  }

  apache::module {
    'userdir':
      source => 'puppet:///modules/gamevial/userdir.conf';
  }

  apache::site {
    [ 'default-ssl' ]:
      ensure => absent;
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
        default           => true,
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
