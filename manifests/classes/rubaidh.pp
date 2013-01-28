class rubaidh {
  include standard

  class {
    'newrelic::agent':
      license_key => '8994aa98999cb87e80a8a988d3320cc7078700ff';

    'postfix::dkim':
      mail_domain => 'rubaidh.com',
      root_email  => 'mathie@rubaidh.com';
  }
}
