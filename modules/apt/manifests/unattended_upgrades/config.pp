class apt::unattended_upgrades::config {
  $notify_email = $apt::unattended_upgrades::notify_email

  file {
    '/etc/apt/apt.conf.d/10periodic':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/apt/10periodic';

    '/etc/apt/apt.conf.d/50unattended-upgrades':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('apt/50unattended-upgrades.erb');
  }
}
