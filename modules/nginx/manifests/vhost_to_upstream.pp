define nginx::vhost_to_upstream(
  $root,
  $aliases                 = [ $name ],
  $additional_port         = undef,
  $vagrant_additional_port = undef,
  $remote_auth_required    = false,
  $extra_ssl_vhost         = false,
  $static_asset_path       = undef,
  $content                 = undef
) {
  nginx::upstream {
    $name:
  }

  nginx::vhost {
    $name:
      content => template('nginx/vhost_to_upstream.conf.erb');
  }

  if $extra_ssl_vhost {
    nginx::vhost {
      "${name}_ssl":
        content => template('nginx/ssl_vhost_to_upstream.conf.erb');
    }
  }

  network::host_alias {
    $name:
  }
}
