class puppet::agent($puppetmaster_hostname = "puppet.${::domain}") {
  include puppet::agent::install, puppet::agent::config, puppet::agent::service

  # The config -> service dependency is deliberately a require (->), not a
  # notifiy (~>) for two reasons:
  #
  # * Puppet seems to get upset and stop working when it restarts itself.
  #
  # * Puppet automatically re-reads config files when they change anyway.
  anchor { 'puppet::agent::begin': } ->
    Class['puppet::agent::install'] ->
    Class['puppet::agent::config'] ->
    Class['puppet::agent::service'] ->
    anchor { 'puppet::agent::end': }
}
