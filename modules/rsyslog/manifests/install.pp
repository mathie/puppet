class rsyslog::install {
  package {
    'rsyslog-gnutls':
      ensure => present;
  }
}
