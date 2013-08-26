class rabbitmq::server::service {
  service {
    'rabbitmq-server':
      ensure     => running,
      enable     => true;
  }
}
