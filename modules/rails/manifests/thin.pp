define rails::thin($ruby_version = '1.9', $rails_env = 'production', $app_servers = 1) {
  $app_name = $name

  class {
    'rails::thin::install':
      ruby_version => $ruby_version;

    'rails::thin::config':
      ruby_version => $ruby_version,
      app_name     => $app_name,
      rails_env    => $rails_env,
      app_servers  => $app_servers;

    'rails::thin::service':
      app_name => $app_name;
  }

  Class['rails::thin::install'] -> Class['rails::thin::config'] ~> Class['rails::thin::service']
}
