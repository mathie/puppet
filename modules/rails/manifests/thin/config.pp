class rails::thin::config($app_name, $ruby_version = '1.9', $rails_env = 'production', $app_servers = 1) {
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

  nginx::upstream {
    "${app_name}_${::hostname}_${rails_env}_thin":
  }

  nginx::vhost {
    "${app_name}_${rails_env}-thin":
      content => template('rails/nginx-thin-vhost.conf.erb');
  }

  if $app_servers == 1 {
    file {
      "/etc/init/${app_name}-thin.conf":
        ensure  => present,
        content => template('rails/upstart-thin.conf.erb'),
        notify  => Service["${app_name}-thin"];
    }

    @@nginx::upstream::server {
      "${app_name}_${::hostname}_${rails_env}_thin_socket":
        upstream => "${app_name}_${::hostname}_${rails_env}_thin",
        target   => "unix:/u/apps/${app_name}/shared/thin.sock",
        options  => "fail_timeout=0";
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
        app_name => $app_name;
    }

    file {
      "/etc/init/${app_name}-thin.conf":
        ensure  => present,
        content => template('rails/upstart-thin-multi-master.conf.erb');
    }
  }
}

define rails::thin::appserver($app_name) {
  $app_server_id = $name

  file {
    "/etc/init/${app_name}-thin-${app_server_id}.conf":
      ensure  => present,
      content => template('rails/upstart-thin-multi.conf.erb'),
      notify  => Service["${app_name}-thin"];
  }

  @@nginx::upstream::server {
    "${app_name}_${::hostname}_${rails_env}_thin_socket_${app_server_id}":
      upstream => "${app_name}_${::hostname}_${rails_env}_thin",
      target   => "unix:/u/apps/${app_name}/shared/thin.${app_server_id}.sock",
      options  => "fail_timeout=0";
  }
}
