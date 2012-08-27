define rails::unicorn($rails_env = 'production') {
  $app_name = $name

  include rails::unicorn::base, rails::unicorn::install

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
