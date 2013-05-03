class puppetdb::server::config {
  nginx::vhost_to_local_upstream {
    'puppetdb':
      upstream_port           => 8080,
      root                    => '/var/lib/puppetdb/www',
      vagrant_additional_port => 8087,
      remote_auth_required    => true,
      content                 => template('puppetdb/nginx.conf.erb');
  }
}
