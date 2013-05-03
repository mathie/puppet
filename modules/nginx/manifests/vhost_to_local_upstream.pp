define nginx::vhost_to_local_upstream(
  $upstream_port,
  $root,
  $aliases                 = [ $name ],
  $additional_port         = undef,
  $vagrant_additional_port = undef,
  $remote_auth_required    = false,
  $content                 = undef
) {

  nginx::vhost_to_upstream {
    $name:
      root                    => $root,
      aliases                 => $aliases,
      additional_port         => $additional_port,
      vagrant_additional_port => $vagrant_additional_port,
      remote_auth_required    => $remote_auth_required,
      content                 => $content;
  }

  nginx::upstream::server {
    "${name}_${::hostname}":
      upstream => $name,
      target   => "127.0.0.1:${upstream_port}",
      options  => 'fail_timeout=0';
  }
}
