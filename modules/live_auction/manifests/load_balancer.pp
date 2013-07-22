class live_auction::load_balancer($rails_env = 'production') {
  nginx::upstream { "live_auction_${rails_env}": }

  nginx::vhost {
    'default':
      content => template('live_auction/nginx-default.conf.erb');

    'ssl':
      content => template('live_auction/nginx-ssl.conf.erb');
  }

  ssl::certificate {
    'bidforwine':
      certificate              => template('live_auction/bidforwine.co.uk.crt'),
      private_key              => template('live_auction/bidforwine.co.uk.key'),
      intermediate_cert_bundle => template('live_auction/intermediate.crt');
  }

  Nginx::Upstream["live_auction_${rails_env}"] -> Nginx::Vhost['default']
  Nginx::Upstream["live_auction_${rails_env}"] -> Nginx::Vhost['ssl']
  Ssl::Certificate['bidforwine']  -> Nginx::Vhost['ssl']
}
