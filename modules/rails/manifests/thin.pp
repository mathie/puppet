define rails::thin::appserver($app_name) {
  $app_server_id = $name

  file {
    "/etc/init/${app_name}-thin-${app_server_id}.conf":
      ensure  => present,
      content => template('rails/upstart-thin-multi.conf.erb'),
      notify  => Service[$app_name];
  }
}

define rails::thin($ruby_version, $rails_env = 'production', $app_servers = 1) {
  $app_name = $name

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
    "/etc/init/${app_name}.conf":
      ensure  => present,
      content => template('rails/upstart-master.conf.erb'),
      notify  => Service[$app_name];
  }

  if $app_servers == 1 {
    file {
      "/etc/init/${app_name}-thin.conf":
        ensure  => present,
        content => template('rails/upstart-thin.conf.erb'),
        notify  => Service[$app_name];
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
        content => template('rails/upstart-thin-multi-master.conf.erb'),
        notify  => Service[$app_name];
    }
  }

  service {
    $app_name:
      ensure     => running,
      enable     => true,
      require    => [ File["/etc/init/${app_name}.conf"], File["/etc/init/${app_name}-thin.conf"] ];
  }
}
