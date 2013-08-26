class ssh::server::service {
  service {
    'ssh':
      ensure => running,
      enable => true;
  }

  @firewall::allow {
    'ssh':
      port => $ssh::server::real_port;
  }

  nagios::check {
    'ssh':
      service_description => 'SSH Server',
      check_command       => 'check_ssh_port',
      groups              => [ 'host' ],
      arguments           => $ssh::server::real_port;
  }
}
