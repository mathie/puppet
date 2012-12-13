class my_ewgeco::worker($rails_env = 'production') {
  rails::sidekiq {
    'my_ewgeco':
      rails_env => $rails_env;
  }

  Class['my_ewgeco::code'] -> Rails::Sidekiq['my_ewgeco']
}
