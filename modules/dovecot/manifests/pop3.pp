class dovecot::pop3 {
  include dovecot::pop3::install, dovecot::pop3::config, dovecot::pop3::service

  Class['dovecot::pop3::install'] -> Class['dovecot::pop3::config'] ~> Class['dovecot::pop3::service']
}
