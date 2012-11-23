class rails::resque::config($app_name, $ruby_version = '1.9', $rails_env = 'production') {
  file {
    "/etc/init/${app_name}-resque.conf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('rails/upstart-resque.conf.erb');
  }
}
