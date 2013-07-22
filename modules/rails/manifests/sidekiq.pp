define rails::sidekiq(
  $ruby_version = '1.9',
  $rails_env    = 'production',
  $concurrency  = 25,
  $queues       = [ 'default' ]
) {
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

    'rails::sidekiq::config':
      ruby_version => $ruby_version,
      app_name     => $app_name,
      rails_env    => $rails_env,
      concurrency  => $concurrency,
      queues       => $queues;

    'rails::sidekiq::service':
      app_name => $app_name;
  }

  Class['rails::sidekiq::install'] -> Class['rails::sidekiq::config'] ~> Class['rails::sidekiq::service']
}
