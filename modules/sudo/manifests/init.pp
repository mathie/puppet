class sudo {
  include sudo::install, sudo::config, sudo::service

  Class['sudo::install'] -> Class['sudo::config'] ~> Class['sudo::service']
}
