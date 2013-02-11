define rabbitmq::server::plugin($ensure = present) {
  if($ensure == 'present') {
    exec {
      "rabbitmq-enable-plugin-${name}":
        command     => "/usr/lib/rabbitmq/bin/rabbitmq-plugins enable ${name}",
        unless      => "/usr/lib/rabbitmq/bin/rabbitmq-plugins list ${name} | /bin/grep '^.E. ${name} '",
        environment => 'HOME=/root',
        notify      => Class['rabbitmq::server::service'];
    }
  } else {
    exec {
      "rabbitmq-disable-plugin-${name}":
        command     => "/usr/lib/rabbitmq/bin/rabbitmq-plugins disable ${name}",
        unless      => "/usr/lib/rabbitmq/bin/rabbitmq-plugins list ${name} | /bin/grep '^. . ${name} '",
        environment => 'HOME=/root',
        notify      => Class['rabbitmq::server::service'];
    }
  }
}
