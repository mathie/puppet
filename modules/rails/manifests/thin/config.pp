class rails::thin::config($app_name, $ruby_version = '1.9', $rails_env = 'production', $app_servers = 1) {
  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',

  }

  $bundler_command  = "${ruby_command} -S bundle"
  $bundle_exec      = "${bundler_command} exec"
  $bundle_exec_args = '-S bundle exec'

  File {
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  nginx::upstream {
    "${app_name}_${::hostname}_${rails_env}":
  }

  nginx::vhost {
    "${app_name}_${rails_env}":
      content => template('rails/nginx-vhost.conf.erb');
  }

  nginx::vhost {
    "${app_name}_${rails_env}_ssl":
      content => template('rails/nginx-ssl-vhost.conf.erb');
  }

  if $app_servers == 1 {
    file {
      "/etc/init/${app_name}-thin.conf":
        ensure  => present,
        content => template('rails/upstart-thin.conf.erb'),
        notify  => Service["${app_name}-thin"];
    }

    @@nginx::upstream::server {
      "${app_name}_${::hostname}_${rails_env}_socket":
        upstream => "${app_name}_${::hostname}_${rails_env}",
        target   => "unix:/u/apps/${app_name}/shared/thin.sock",
        options  => 'fail_timeout=0';
    }

  } else {
    $app_server_arrays = {
      1 => [1],
      2 => [1, 2],
      3 => [1, 2, 3],
      4 => [1, 2, 3, 4],
    }
    $app_server_array = $app_server_arrays[$app_servers]

    rails::thin::appserver {
      $app_server_array:
        app_name  => $app_name,
        rails_env => $rails_env;
    }

    file {
      "/etc/init/${app_name}-thin.conf":
        ensure  => present,
        content => template('rails/upstart-thin-multi-master.conf.erb');
    }
  }
}
