class standard::itison {
  $admin_email = 'gavin.montague@itison.com'

  include standard

  class {
    'newrelic::agent':
      license_key => '8b638f2c1c5a2eec1bd1e83d48d986d24f265aab';

    'postfix::dkim':
      mail_domain => 'itison.com',
      root_email  => $admin_email;

    'apt::unattended_upgrades':
      notify_email => $admin_email;

    'ssh::server':
      port => 2712;

    'fail2ban':
      email     => [
        'gavin.montague@itison.com',
        'gavin@leftbrained.co.uk'
      ],
      whitelist => [
        '46.226.7.250' # Dada office
      ];
  }

  include itison::hosts

  users::account {
    'mathie':
      uid      => 10001,
      password => '$6$sIQnqvVz$LOocGXi65myfyIne7knOr0KL0QkjReLbuSe9Fe5ct.jGOVTWf6NID4toF6Pkm5I5nRldC4CtcC.kyLo6ddZKQ0',
      htpasswd => '$apr1$z7n8mzjB$rNsr7NhLnqPDnR.Pd20zz0',
      comment  => 'Graeme Mathieson',
      email    => 'mathie@rubaidh.com',
      sudo     => true;

    'gavin':
      uid      => 10002,
      password => '$6$9vPpmPgz$lZ0OtkwGMkPexqIwrISDFHlvnNSDXmWZlZ7NnpB2Pa0ovIYpDWUdyaOw6yLzgPC/uNlfToLIZw8bDHcs3tcV7/',
      htpasswd => '$1$.Habz1iH$.14.hvJ./KJLtR4yxs/o4.',
      comment  => 'Gavin Montague',
      email    => 'gavin.montague@itison.com',
      sudo     => true;
  }
}
