class jenkins::slave {
  include jenkins::slave::install, jenkins::slave::config, jenkins::slave::service

  Class['jenkins::slave::install'] -> Class['jenkins::slave::config'] ~> Class['jenkins::slave::service']
}
