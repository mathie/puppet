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

  $vhost_fqdn = "${name}.${::domain}"

  nginx::nrpe_check {
    $vhost_fqdn:
      authenticated => $remote_auth_required;
  }

  $nagios_auth_args = $remote_auth_required ? {
    true    => " -a ${nagios::agent::htpasswd_user}:${nagios::agent::htpasswd_password}",
    default => '',
  }
  $shared_args = "-H ${vhost_fqdn} -I 127.0.0.1${nagios_auth_args}"

  if $additional_port {
    nginx::nrpe_check {
      "${vhost_fqdn}-${additional_port}":
        vhost         => $vhost_fqdn,
        authenticated => $remote_auth_required,
        port          => $additional_port;
    }
  }

  if $vagrant == 'true' and $vagrant_additional_port {
    nginx::nrpe_check {
      "${vhost_fqdn}-${vagrant_additional_port}":
        vhost         => $vhost_fqdn,
        authenticated => $remote_auth_required,
        port          => $vagrant_additional_port;
    }
  }

  if $extra_ssl_vhost {
    nginx::vhost {
      "${name}_ssl":
        content => template('nginx/ssl_vhost_to_upstream.conf.erb');
    }

    nginx::nrpe_check {
      "${vhost_fqdn}-ssl":
        vhost         => $vhost_fqdn,
        authenticated => $remote_auth_required,
        ssl           => true;
    }
  }

  network::host_alias {
    $name:
  }
}
