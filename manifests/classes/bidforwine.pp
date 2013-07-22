class standard::bidforwine {
  include standard

  class {
    'newrelic::agent':
      license_key => '8994aa98999cb87e80a8a988d3320cc7078700ff';

    'postfix::dkim':
      mail_domain => 'bidforwine.co.uk',
      root_email  => 'mathie@rubaidh.com';

    'apt::unattended_upgrades':
      notify_email => 'mathie@rubaidh.com';
  }

  users::account {
    'mathie':
      uid      => 10001,
      password => '$6$sIQnqvVz$LOocGXi65myfyIne7knOr0KL0QkjReLbuSe9Fe5ct.jGOVTWf6NID4toF6Pkm5I5nRldC4CtcC.kyLo6ddZKQ0',
      htpasswd => '$apr1$z7n8mzjB$rNsr7NhLnqPDnR.Pd20zz0',
      comment  => 'Graeme Mathieson',
      email    => 'mathie@rubaidh.com',
      sudo     => true;

    'lenary':
      uid      => 10005,
      password => '$6$Yze3T6nE$7qPLgCniquBgllNSEN8eKhgs7oDDIGlR/XdlHcMXJmBQgRSHoz7Gk8i16PuD6UYeBzghws7o4MiOuYfgv96mA.',
      comment  => 'Sam Elliott',
      email    => 'sam@lenary.co.uk',
      sudo     => true;

    'lionel':
      uid      => 10006,
      password => '$6$8K7xzGId$2iNZmMAQ3F6TgWggURL1q.YsfUImhHye9YpjY8f5vaZRqO4t55vHgQKAycQC4NHsYPocdh7tZSpne4MB40bEJ/',
      email    => 'lionel@bidforwine.co.uk',
      comment  => 'Lionel Nierop';

  }
}
