class postfix::smtp_auth($mail_domain = $domain, $root_email = "root@${mail_domain}", $destination = undef) {
  class {
    'postfix':
      mail_domain => $mail_domain,
      destination => $destination,
      root_email  => $root_email;
  }

  include sasl::saslauthd

  file {
    '/etc/postfix/sasl/smtpd.conf':
      ensure => present,
      source => 'puppet:///modules/postfix/sasl2-smtp.conf',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  postfix::config::fragment {
    'smtpd_sasl_auth_enable':
      value => 'yes';

    'smtpd_sasl_security_options':
      value => 'noanonymous';

    'smtpd_recipient_restrictions':
      value => 'permit_mynetworks permit_sasl_authenticated reject_unauth_destination';

    'smtpd_sasl_authenticated_header':
      value => 'yes';

    'broken_sasl_auth_clients':
      value => 'yes';
  }
}
