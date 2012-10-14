class opendkim($mail_domain = $domain) {
  include opendkim::install, opendkim::service

  class {
    'opendkim::config':
      mail_domain => $mail_domain;
  }

  Class['opendkim::install'] -> Class['opendkim::config'] ~> Class['opendkim::service']
}
