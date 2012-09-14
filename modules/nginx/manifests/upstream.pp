define nginx::upstream {
  concat::file {
    "nginx-upstream-${name}":
      path  => "/etc/nginx/upstreams.d/upstream-${name}.conf",
      owner => root,
      group => root,
      mode  => '0644',
      head  => "upstream ${name} {\n",
      tail  => "}";
  }

  Nginx::Upstream::Server <<| upstream == $name |>>
}
