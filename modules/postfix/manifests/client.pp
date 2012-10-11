class postfix::client {
  include postfix::install, postfix::client::config, postfix::service

  Class['postfix::install'] -> Class['postfix::client::config'] ~> Class['postfix::service']
}
