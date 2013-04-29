define rails::thin::appserver($app_name, $rails_env = 'production') {
  $app_server_id = $name

  file {
    "/etc/init/${app_name}-thin-${app_server_id}.conf":
      ensure  => present,
      content => template('rails/upstart-thin-multi.conf.erb'),
      notify  => Service["${app_name}-thin"];
  }

  @@nginx::upstream::server {
    "${app_name}_${::hostname}_${rails_env}_socket_${app_server_id}":
      upstream => "${app_name}_${::hostname}_${rails_env}",
      target   => "unix:/u/apps/${app_name}/shared/thin.${app_server_id}.sock",
      options  => 'fail_timeout=0';
  }
}
