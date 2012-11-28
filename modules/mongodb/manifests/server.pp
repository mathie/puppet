class mongodb::server {
  include mongodb::server::install,
    mongodb::server::config,
    mongodb::server::service

  Class['mongodb::server::install'] ->
    Class['mongodb::server::config'] ~>
    Class['mongodb::server::service']
}
