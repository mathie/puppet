class my_ewgeco::app_server($rails_env = 'production') {
  rails::thin {
    'my_ewgeco':
      rails_env   => $rails_env,
      app_servers => 4;
  }

  Class['my_ewgeco::code'] -> Rails::Thin['my_ewgeco']

  @@nginx::upstream::server {
    "my_ewgeco-appserver-${::hostname}-${rails_env}":
      upstream => "my_ewgeco-${rails_env}",
      target   => "${::ipaddress_preferred}:80",
      options  => 'fail_timeout=2';
  }

  @@nginx::upstream::server {
    "my_ewgeco-appserver-${::hostname}-${rails_env}_ssl":
      upstream => "my_ewgeco-${rails_env}_ssl",
      target   => "${::ipaddress_preferred}:443",
      options  => 'fail_timeout=2';
  }
}
