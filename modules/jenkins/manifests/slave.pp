class jenkins::slave($master) {
  include jenkins::slave::install, jenkins::slave::service

  class {
    'jenkins::slave::config':
      master => $master;
  }

  Class['jenkins::slave::install'] -> Class['jenkins::slave::config'] ~> Class['jenkins::slave::service']
}
