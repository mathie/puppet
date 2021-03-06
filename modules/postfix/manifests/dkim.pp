class postfix::dkim($mail_domain = $domain, $root_email = "root@${mail_domain}", $destination = undef) {
  class {
    'postfix':
      mail_domain => $mail_domain,
      destination => $destination,
      root_email  => $root_email;

    'opendkim':
      mail_domain => $mail_domain;
  }

  postfix::config::fragment {
    'smtpd_milters':
      value => 'inet:127.0.0.1:8891';

    'non_smtpd_milters':
      value => 'inet:127.0.0.1:8891';
  }
}
