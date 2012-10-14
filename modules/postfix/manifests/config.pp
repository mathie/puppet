class postfix::config($mail_domain = $domain) {
  file {
    '/etc/mailname':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/mailname.erb');

    '/etc/postfix/master.cf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/master.cf.erb');
  }

  concat::file {
    'postfix-main-cf':
      path  => '/etc/postfix/main.cf',
      owner => root,
      group => root,
      mode  => '0644',
      head  => template('postfix/main.cf.erb');
  }
}
