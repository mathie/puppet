class rabbitmq::stomp(
  $clients = undef
) {

  class {
    'rabbitmq::server':
      clients => $clients;
  }

  exec {
    'install-rabbitmq-stomp':
      command     => '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install rabbitmq-stomp',
      unless      => '/usr/bin/dpkg -l rabbitmq-stomp | /bin/grep ^ii',
      environment => 'HOME=/root';
  }

  @firewall::allow {
    'rabbitmq-stomp':
      port    => '61613',
      sources => $clients;
  }

  Class['rabbitmq::stomp'] ~> Class['rabbitmq::server::service']
}
