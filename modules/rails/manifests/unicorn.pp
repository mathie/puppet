define rails::unicorn($ruby_version = '1.9', $rails_env = 'production') {
  $app_name = $name

  class {
    'rails::unicorn::install':
      ruby_version => $ruby_version;

    'rails::unicorn::config':
      ruby_version => $ruby_version,
      app_name     => $app_name,
      rails_env    => $rails_env;

    'rails::unicorn::service':
      app_name => $app_name;
  }

  Class['rails::unicorn::install'] -> Class['rails::unicorn::config'] ~> Class['rails::unicorn::service']
}
