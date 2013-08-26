class rabbitmq::server::management {
  rabbitmq::server::plugin {
    'rabbitmq_management':
      ensure => present;
  }

  @firewall::allow {
    'rabbitmq-management-plugin-old-port':
      port => 55672;

    'rabbitmq-management-plugin':
      port => 15672;
  }
}
