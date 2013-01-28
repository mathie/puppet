class dovecot::pop3::install {
  package {
    'dovecot-pop3d':
      ensure => present;
  }
}
