class rabbitmq::server::install {
  package {
    'rabbitmq-server':
      ensure => present,
  }
}
