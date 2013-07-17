class standard::rubaidh {
  include standard

  class {
    'newrelic::agent':
      license_key => '8994aa98999cb87e80a8a988d3320cc7078700ff';

    'postfix::dkim':
      mail_domain => 'rubaidh.com',
      root_email  => 'mathie@rubaidh.com';

    'apt::unattended_upgrades':
      notify_email => 'mathie@rubaidh.com';

    'fail2ban':
      email => [ 'mathie@rubaidh.com' ];
  }

  users::account {
    'mathie':
      uid      => 10001,
      password => '$6$sIQnqvVz$LOocGXi65myfyIne7knOr0KL0QkjReLbuSe9Fe5ct.jGOVTWf6NID4toF6Pkm5I5nRldC4CtcC.kyLo6ddZKQ0',
      htpasswd => '$apr1$z7n8mzjB$rNsr7NhLnqPDnR.Pd20zz0',
      comment  => 'Graeme Mathieson',
      email    => 'mathie@rubaidh.com',
      sudo     => true;
  }
}
