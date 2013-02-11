class standard::itison {
  include standard

  class {
    'newrelic::agent':
      license_key => '8b638f2c1c5a2eec1bd1e83d48d986d24f265aab';

    'postfix::dkim':
      mail_domain => 'itison.com',
      root_email  => 'gavin@itison.com';
  }

  include itison::hosts
}
