class rails::sidekiq::config($app_name, $ruby_version = '1.9', $rails_env = 'production', $concurrency = 25) {
  file {
    "/etc/init/${app_name}-sidekiq.conf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('rails/upstart-sidekiq.conf.erb');
  }
}
