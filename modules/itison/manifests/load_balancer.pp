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

  fail2ban::jail::nginx {
    'nginx':
      ensure => present;

    'nginx_scripts':
      ensure   => present,
      maxretry => 2,
      findtime => 120;

    'rails_attacks':
      ensure   => present,
      maxretry => 1;
  }
}
