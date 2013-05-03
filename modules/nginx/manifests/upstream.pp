define nginx::upstream {
  include nginx

  concat::file {
    "nginx-upstream-${name}":
      path  => "/etc/nginx/upstreams.d/upstream-${name}.conf",
      owner => root,
      group => root,
      mode  => '0644',
      head  => "upstream ${name} {\n",
      tail  => "}\n";
  }

  nginx::upstream::server {
    "${name}-${::hostname}-dummy-upstream":
      upstream => $name,
      target   => '127.0.0.1:65535',
      options  => 'down';
  }

  Nginx::Upstream::Server <<| upstream == $name |>>

  Class['nginx'] -> Concat::File["nginx-upstream-${name}"] ~> Class['nginx::service']
}
