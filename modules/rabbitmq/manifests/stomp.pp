class rabbitmq::stomp {
  include rabbitmq::server

  package {
    'rabbitmq-stomp':
      ensure => present,
  }

  firewall::allow {
    'rabbitmq-stomp':
      port => '61613';
  }

  Class['rabbitmq::stomp'] ~> Class['rabbitmq::server::service']
}
