class dovecot::pop3::config {
  file {
    '/etc/dovecot/conf.d/10-auth.conf':
      ensure => present,
      source => 'puppet:///modules/dovecot/10-auth.conf',
      owner  => root,
      group  => root,
      mode   => '0644';
  }
}
