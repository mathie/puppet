class puppet::master($ssh_key, $git_repo) {
  include puppet::agent
  include puppet::master::install, puppet::master::config, puppet::master::service

  anchor { 'puppet::master::begin': } ->
    Class['puppet::master::install'] ->
    Class['puppet::master::config'] ~>
    Class['puppet::master::service'] ->
    anchor { 'puppet::master::end': }
}
