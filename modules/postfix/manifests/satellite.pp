class postfix::satellite(
  $relayhost,
  $mail_domain = $domain,
  $root_email  = "root@${mail_domain}",
  $username    = undef,
  $password    = undef,
  $port        = 587
) {
  class {
    'postfix':
      mail_domain => $mail_domain,
      root_email  => $root_email;
  }

  postfix::config::fragment {
    'stmp_tls_security_level':
      value => 'may';

    'start_tls':
      value => 'yes';

    'header_size_limit':
      value => '4096000';

    'relayhost':
      value => "[${relayhost}]:${port}";
  }

  if $username {
    postfix::config::fragment {
      'smtp_sasl_auth_enable':
        value => 'yes';

      'smtp_sasl_password_maps':
        value => "static:${username}:${password}";

      'smtp_sasl_security_options':
        value => 'noanonymous';
    }
  }
}
