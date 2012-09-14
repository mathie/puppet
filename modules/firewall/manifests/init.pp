class firewall {
  $enabled = true

  include firewall::install, firewall::config, firewall::service

  Class['firewall::install'] -> Class['firewall::config'] ~> Class['firewall::service']
}
