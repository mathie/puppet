class rails::unicorn::config($app_name, $ruby_version = '1.9', $rails_env = 'production') {
  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',
  }

  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"

  File {
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  file {
    '/etc/unicorn':
      ensure => directory;

    "/etc/unicorn/${app_name}.rb":
      ensure  => present,
      content => template('rails/unicorn.rb.erb');

    "/etc/init/${app_name}-unicorn.conf":
      ensure  => present,
      content => template('rails/upstart-unicorn.conf.erb');
  }

  nginx::upstream {
    "${app_name}_${::hostname}_${rails_env}_unicorn":
  }

  @@nginx::upstream::server {
    "${app_name}_${::hostname}_${rails_env}_unicorn_socket":
      upstream => "${app_name}_${::hostname}_${rails_env}_unicorn",
      target   => "unix:/u/apps/${app_name}/shared/unicorn.sock",
      options  => 'fail_timeout=0';
  }

  nginx::vhost {
    "${app_name}_${rails_env}-unicorn":
      content => template('rails/nginx-unicorn-vhost.conf.erb');
  }
}
