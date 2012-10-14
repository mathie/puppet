class postfix::config {
  file {
    '/etc/postfix/master.cf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/master.cf.erb');

    '/etc/postfix/main.cf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/main.cf.erb');
  }
}
