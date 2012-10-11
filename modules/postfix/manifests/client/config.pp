class postfix::client::config {
  include postfix::config

  file {
    '/etc/postfix/main.cf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('postfix/client/main.cf.erb');
  }

  Class['postfix::config'] ~> Class['postfix::service']
}
