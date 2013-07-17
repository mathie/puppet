class itison::load_balancer($rails_env = 'production', $mobile = false) {
  include nginx::proxy_cache

  nginx::upstream { "itison_${rails_env}": }
  nginx::upstream { "itison_${rails_env}_ssl": }
  nginx::upstream { "itison_email_${rails_env}": }
  nginx::upstream { "itison_email_${rails_env}_ssl": }
  nginx::upstream { "itison_asset_${rails_env}": }
  nginx::upstream { "itison_asset_${rails_env}_ssl": }

  itison::load_balancer::vhost {
    'default':
      rails_env => $rails_env,
      ssl       => false;

    'ssl':
      rails_env => $rails_env,
      ssl       => true;
  }

  $key_name = $mobile ? {
    true    => 'm.itison.com',
    default => 'itison.com',
  }

  ssl::certificate {
    'itison':
      certificate              => template("itison/${key_name}.crt"),
      private_key              => template("itison/${key_name}.key"),
      intermediate_cert_bundle => template('itison/gd_bundle.crt');
  }

  include fail2ban::filter::nginx
  fail2ban::jail {
    'nginx':
      ensure   => present,
      port     => 'http,https',
      filter   => 'nginx',
      logpath  => '/var/log/nginx/access.log',
      maxretry => 50,
      bantime => 604800,
      findtime => 60;
  }
  fail2ban::jail {
    'nginx_scripts':
      ensure   => present,
      port     => 'http,https',
      filter   => 'nginx_scripts',
      logpath  => '/var/log/nginx/access.log',
      maxretry => 2,
      bantime => 604800,
      findtime => 120;
  }
  fail2ban::jail {
    'rails_attacks':
      ensure   => present,
      port     => 'http,https',
      filter   => 'rails_attacks',
      logpath  => '/var/log/nginx/access.log',
      maxretry => 1,
      bantime => 604800,
      findtime => 60;
  }
}
