class ssh::server {
  include ssh::server::install, ssh::server::config, ssh::server::service

  Class['ssh::server::install'] -> Class['ssh::server::config'] ~> Class['ssh::server::service']
}
