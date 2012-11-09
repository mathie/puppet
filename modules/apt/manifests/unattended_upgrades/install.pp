class apt::unattended_upgrades::install {
  package {
    'unattended-upgrades':
      ensure => present;
  }
}
