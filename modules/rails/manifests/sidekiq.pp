define rails::sidekiq($rails_env = 'production') {
  $app_name = $name

  include rails::sidekiq::install

  File {
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  file {
    "/etc/init/${app_name}-sidekiq.conf":
      ensure  => present,
      content => template('rails/upstart-sidekiq.conf.erb'),
      notify  => Service[$app_name];
  }
}
