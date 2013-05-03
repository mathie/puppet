define nginx::user($password, $ensure = present) {
  @concat::fragment {
    "nginx-htpasswd-${name}":
      ensure  => $ensure,
      file    => 'nginx-htpasswd',
      content => "${name}:${password}\n";
  }
}
