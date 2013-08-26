define nginx::vhost_to_upstream(
  $root,
  $aliases                 = [ $name ],
  $additional_port         = undef,
  $vagrant_additional_port = undef,
  $remote_auth_required    = false,
  $extra_ssl_vhost         = false,
  $main_port               = 80,
  $ssl_port                = 443,
  $static_asset_path       = undef,
  $permitted_clients       = undef,
  $content                 = undef,
  $ssl_certificate         = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $ssl_certificate_key     = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
) {
  nginx::upstream {
    $name:
  }

  nginx::vhost {
    $name:
      content => template('nginx/vhost_to_upstream.conf.erb');
  }

  @firewall::allow {
    "firewall-${name}-${main_port}":
      sources => $permitted_clients,
      port    => $main_port;
  }

  if $additional_port {
    @firewall::allow {
      "firewall-${name}-${additional_port}":
        sources => $permitted_clients,
        port    => $additional_port;
    }
  }

  if str2bool($::vagrant) == true and $vagrant_additional_port {
    @firewall::allow {
      "firewall-${name}-${vagrant_additional_port}":
        sources => $permitted_clients,
        port    => $vagrant_additional_port;
    }
  }

  if $extra_ssl_vhost {
    nginx::vhost {
      "${name}_ssl":
        content => template('nginx/ssl_vhost_to_upstream.conf.erb');
    }

    @firewall::allow {
      "firewall-${name}-${ssl_port}":
        sources => $permitted_clients,
        port    => $ssl_port;
    }
  }

  if $name != $::hostname {
    network::host_alias {
      $name:
    }
  }
}
