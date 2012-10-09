class rabbitmq::server::management {
  rabbitmq::server::plugin {
    'rabbitmq_management':
      ensure => present;
  }

  firewall::allow {
    'rabbitmq-management-plugin':
      port => 55672;
  }
}
