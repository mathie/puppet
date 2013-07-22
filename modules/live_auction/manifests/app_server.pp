class live_auction::app_server($rails_env = 'production') {
  if !defined(Class['live_auction::code']) {
    class {
      'live_auction::code':
        rails_env => $rails_env;
    }
  }

  rails::thin {
    'live_auction':
      rails_env   => $rails_env,
      app_servers => 4;
  }

  Class['live_auction::code'] -> Rails::Thin['live_auction']

  @@nginx::upstream::server {
    "live_auction-appserver-${::hostname}-${rails_env}":
      upstream => "live_auction_${rails_env}",
      target   => "${::ipaddress_preferred}:80",
      options  => 'fail_timeout=2';
  }
}
