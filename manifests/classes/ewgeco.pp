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

    'ewgeco':
      uid                 => 10002,
      comment             => 'Ewgeco Operations',
      htpasswd            => '$apr1$hRNHk998$kuPFRkI/RyEUWcsRChX5m1', # xieZi8ie
      ssh_authorized_keys => false,
      email               => 'operations@ewgeco.com';

  }
}
