class rabbitmq::server::config {
  firewall::allow {
    'amqp':
      port => '5672';
  }
}
