class opendkim::config($mail_domain = $domain) {
  file {
    '/etc/opendkim.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('opendkim/opendkim.conf.erb');

    '/etc/default/opendkim':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/opendkim/etc-default-opendkim';
  }

  file {
    '/etc/opendkim':
      ensure => directory,
      owner  => 'opendkim',
      group  => 'opendkim',
      mode   => '0700';
  }

  exec {
    'opendkim-genkey':
      command => "/usr/bin/opendkim-genkey -d ${::domain} -D /etc/opendkim -s ${::hostname}",
      creates => "/etc/opendkim/${::hostname}.private",
      require => File['/etc/opendkim'];
  }

  file {
    "/etc/opendkim/${::hostname}.private":
      ensure  => present,
      owner   => 'opendkim',
      group   => 'opendkim',
      mode    => '0600',
      require => Exec['opendkim-genkey'];
  }
}
