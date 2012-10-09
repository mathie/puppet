class crtmpserver {
  include crtmpserver::install, crtmpserver::config, crtmpserver::service

  Class['crtmpserver::install'] -> Class['crtmpserver::config'] ~> Class['crtmpserver::service']
}
