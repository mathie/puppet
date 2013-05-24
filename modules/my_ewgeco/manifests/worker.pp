class my_ewgeco::worker($rails_env = 'production', $concurrency = 25) {
  rails::sidekiq {
    'my_ewgeco':
      rails_env   => $rails_env,
      concurrency => $concurrency;
  }

  Class['my_ewgeco::code'] -> Rails::Sidekiq['my_ewgeco']
}
