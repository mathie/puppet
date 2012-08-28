define rails::unicorn($rails_env = 'production') {
  $app_name = $name

  $ruby_command = $ruby_version ? {
    '1.8' => '/usr/bin/ruby1.8',
    '1.9' => '/usr/bin/ruby1.9.1',

  }

  $bundler_command = "${ruby_command} -S bundle"
  $bundle_exec     = "${bundler_command} exec"

  class {
    'rails::unicorn::install':
      ruby_version => $ruby_version;
  }

  include rails::unicorn::base

  File {
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  file {
    "/etc/unicorn/${app_name}.rb":
      ensure  => present,
      content => template('rails/unicorn.rb.erb'),
      require => [ Class['rails::unicorn::base'], Class['rails::unicorn::install'] ],
      notify  => Service[$app_name];

    "/etc/init/${app_name}.conf":
      ensure  => present,
      content => template('rails/upstart-master.conf.erb'),
      require => File["/etc/unicorn/${app_name}.rb"],
      notify  => Service[$app_name];

    "/etc/init/${app_name}-unicorn.conf":
      ensure  => present,
      content => template('rails/upstart-unicorn.conf.erb'),
      require => File["/etc/unicorn/${app_name}.rb"],
      notify  => Service[$app_name];
  }

  service {
    $app_name:
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      enable     => true,
      require    => [ File["/etc/init/${app_name}.conf"], File["/etc/init/${app_name}-unicorn.conf"] ];
  }

}
