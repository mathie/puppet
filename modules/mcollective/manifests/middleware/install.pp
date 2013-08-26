class mcollective::middleware::install {
  class {
    'rabbitmq::stomp':
      clients => $mcollective::middleware::clients;
  }

  exec {
    'mcollective-rabbitmq-user':
      command => '/usr/sbin/rabbitmqctl add_user mcollective secret && /usr/sbin/rabbitmqctl set_permissions mcollective ".*" ".*" ".*"',
      unless  => '/usr/sbin/rabbitmqctl list_users | grep mcollective >/dev/null 2>&1',
      require => Class['rabbitmq::server::service'],
  }

  package { 'mcollective-middleware':
    ensure  => present,
    require => [ Class['rabbitmq::stomp'], Exec['mcollective-rabbitmq-user'] ],
  }
}
