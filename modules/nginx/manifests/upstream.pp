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

  Nginx::Upstream::Server <<| upstream == $name |>>

  Class['nginx'] -> Concat::File["nginx-upstream-${name}"] ~> Class['nginx::service']
}
