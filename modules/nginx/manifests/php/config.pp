class nginx::php::config {
  nginx::upstream { 'php': }

  nginx::upstream::server {
    "php_socket_${::hostname}":
      upstream => 'php',
      target   => 'localhost:9000';
  }
}
