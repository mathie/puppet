class postfix($mail_domain = $domain) {
  include postfix::install, postfix::service

  class {
    'postfix::config':
      mail_domain => $mail_domain;
  }

  Class['postfix::install'] -> Class['postfix::config'] ~> Class['postfix::service']
}
