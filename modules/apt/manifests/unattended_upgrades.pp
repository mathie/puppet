class apt::unattended_upgrades($notify_email = undef) {
  include apt::unattended_upgrades::install, apt::unattended_upgrades::config

  Class['apt::unattended_upgrades::install'] ->
    Class['apt::unattended_upgrades::config']
}
