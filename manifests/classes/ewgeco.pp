class standard::ewgeco {
  include standard

  class {
    'newrelic::agent':
      license_key => '27e148c1212e137eb1254c70fe1cdd633d018056';

    'postfix::satellite':
      mail_domain => 'ewgeco.com',
      root_email  => 'mathie@rubaidh.com',
      relayhost   => 'smtp.sendgrid.net',
      username    => 'gordon@ewgeco.com',
      password    => 'telf0rd*7';
  }
}
