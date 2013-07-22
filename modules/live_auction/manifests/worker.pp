class live_auction::worker($rails_env = 'production') {
  if !defined(Class['live_auction::code']) {
    class {
      'live_auction::code':
        rails_env => $rails_env;
    }
  }

  rails::sidekiq {
    'live_auction':
      rails_env => $rails_env,
      queues    => [ 'default', 'store_asset', 'process_asset' ];
  }

  Class['live_auction::code'] -> Rails::Sidekiq['live_auction']
}
