class jenkins {
  include jenkins::install, jenkins::config, jenkins::service

  Class['jenkins::install'] -> Class['jenkins::config'] ~> Class['jenkins::service']
}
