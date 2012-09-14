define nginx::upstream::server($upstream, $target, $options = '', $order = 50) {
  concat::fragment {
    "nginx-upstream-server-${upstream}-${name}":
      file    => "nginx-upstream-${upstream}",
      order   => $order,
      content => template('nginx/upstream-server.conf.erb');
  }
}
