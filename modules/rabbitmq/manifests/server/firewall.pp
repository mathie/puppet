class rabbitmq::server::firewall {

  @firewall::allow {
    'amqp':
      port    => '5672',
      sources => $rabbitmq::server::clients;
  }
}
