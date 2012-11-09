class apt::unattended_upgrades {
  include apt::unattended_upgrades::install, apt::unattended_upgrades::config

  Class['apt::unattended_upgrades::install'] -> Class['apt::unattended_upgrades::config']
}
