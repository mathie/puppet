define itison::load_balancer::vhost($ssl = false, $rails_env = 'production') {
  nginx::vhost {
    $name:
      content => template('itison/nginx-vhost.conf.erb');
  }

  Nginx::Upstream["itison_${rails_env}"]       -> Nginx::Vhost[$name]
  Nginx::Upstream["itison_email_${rails_env}"] -> Nginx::Vhost[$name]

  if $ssl {
    Ssl::Certificate['itison'] -> Nginx::Vhost[$name]
  }
}
