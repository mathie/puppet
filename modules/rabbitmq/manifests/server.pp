class rabbitmq::server {
  include rabbitmq::server::install, rabbitmq::server::config, rabbitmq::server::service
  Class['rabbitmq::server::install'] -> Class['rabbitmq::server::config'] ~> Class['rabbitmq::server::service']
}
