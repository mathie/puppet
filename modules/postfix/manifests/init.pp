class postfix($mail_domain = $domain, $root_email = "root@${mail_domain}", $destination = undef) {
  include postfix::install, postfix::service

  class {
    'postfix::config':
      mail_domain => $mail_domain,
      root_email  => $root_email,
      destination => $destination;
  }

  Class['postfix::install'] -> Class['postfix::config'] ~> Class['postfix::service']
}
