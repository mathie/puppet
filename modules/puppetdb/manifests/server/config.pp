class puppetdb::server::config {
  nginx::vhost_to_local_upstream {
    'puppetdb':
      upstream_port           => 8080,
      root                    => '/var/lib/puppetdb/www',
      vagrant_additional_port => 8087,
      permitted_clients       => [ '127.0.0.1' ],
      content                 => template('puppetdb/nginx.conf.erb');
  }
}
