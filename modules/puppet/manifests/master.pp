class puppet::master($ssh_key, $git_repo) {
  include puppet::agent
  include puppet::master::install, puppet::master::config, puppet::master::service

  # The config -> service dependency is deliberately a require (->), not a
  # notifiy (~>) for two reasons:
  #
  # * Puppet seems to get upset and stop working when it restarts itself.
  #
  # * Puppet automatically re-reads config files when they change anyway.
  anchor { 'puppet::master::begin': } ->
    Class['puppet::master::install'] ->
    Class['puppet::master::config'] ->
    Class['puppet::master::service'] ->
    anchor { 'puppet::master::end': }
}
