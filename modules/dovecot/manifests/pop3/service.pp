class dovecot::pop3::service {
  service {
    'dovecot':
      ensure => running,
      enable => true;
  }
}
