define rails::resque($ruby_version = '1.9', $rails_env = 'production') {
  $app_name = $name

  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',

  }

  $bundler_command  = "${ruby_command} -S bundle"
  $bundle_exec      = "${bundler_command} exec"
  $bundle_exec_args = '-S bundle exec'

  class {
    'rails::resque::install':
      ruby_version => $ruby_version;

    'rails::resque::config':
      ruby_version => $ruby_version,
      app_name     => $app_name,
      rails_env    => $rails_env;

    'rails::resque::service':
      app_name => $app_name;
  }

  Class['rails::resque::install'] -> Class['rails::resque::config'] ~> Class['rails::resque::service']
}
