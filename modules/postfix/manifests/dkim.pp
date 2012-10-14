class postfix::dkim($mail_domain = $domain) {
  class {
    'postfix':
      mail_domain => $mail_domain;

    'opendkim':
      mail_domain => $mail_domain;
  }

  postfix::config::fragment {
    'smtpd-milters':
      key   => 'smtpd_milters',
      value => 'inet:127.0.0.1:8891';

    'non-smtpd-milters':
      key   => 'non_smtpd_milters',
      value => 'inet:127.0.0.1:8891';
  }
}