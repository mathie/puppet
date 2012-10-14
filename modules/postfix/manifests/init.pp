class postfix {
  include postfix::install, postfix::config, postfix::service

  Class['postfix::install'] -> Class['postfix::config'] ~> Class['postfix::service']
}
