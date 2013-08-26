class firewall($enabled = true) {
  include firewall::install, firewall::config, firewall::service

  anchor { 'firewall::begin': } ->
  Class['firewall::install'] ->
    Class['firewall::config'] ~>
    Class['firewall::service'] ->
    anchor { 'firewall::end': }
}
