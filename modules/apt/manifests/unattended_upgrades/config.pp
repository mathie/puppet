class apt::unattended_upgrades::config {
  file {
    '/etc/apt/apt.conf.d/50unattended-upgrades':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/apt/50unattended-upgrades';
  }
}
