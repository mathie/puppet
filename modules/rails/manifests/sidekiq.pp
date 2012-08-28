define rails::sidekiq($ruby_version, $rails_env = 'production') {
  $app_name = $name

  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',

  }

  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"

  class {
    'rails::sidekiq::install':
      ruby_version => $ruby_version;
  }

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
