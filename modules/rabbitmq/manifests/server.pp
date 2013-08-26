class rabbitmq::server(
  $clients = undef
) {
  include rabbitmq::server::firewall,
    rabbitmq::server::install,
    rabbitmq::server::config,
    rabbitmq::server::service

  anchor { 'rabbitmq::server::begin': } ->
    Class['rabbitmq::server::firewall'] ->
    Class['rabbitmq::server::install'] ->
    Class['rabbitmq::server::config'] ~>
    Class['rabbitmq::server::service'] ->
    anchor { 'rabbitmq::server::end': }
}
