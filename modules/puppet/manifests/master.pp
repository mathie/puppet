class puppet::master(
  $ssh_key,
  $git_repo,
  $clients = undef
) {
  include puppet::agent
  include puppet::master::firewall, puppet::master::install, puppet::master::repo, puppet::master::config, puppet::master::service

  anchor { 'puppet::master::begin': } ->
    Class['puppet::master::firewall'] ->
    Class['puppet::master::install'] ->
    Class['puppet::master::repo'] ->
    Class['puppet::master::config'] ~>
    Class['puppet::master::service'] ->
    anchor { 'puppet::master::end': }
}
