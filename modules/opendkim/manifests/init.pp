class opendkim {
  include opendkim::install, opendkim::config, opendkim::service

  Class['opendkim::install'] -> Class['opendkim::config'] ~> Class['opendkim::service']
}
