class rabbitmq::server::service {
  service {
    'rabbitmq-server':
      ensure     => running,
      enable     => true;
  }

  firewall::allow {
    'amqp':
      port => '5672';
  }
}
