class postfix::config {
  file {
    '/etc/postfix/main.cf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/main.cf.erb');
  }
}
