class puppet::agent {
  include puppet::agent::install, puppet::agent::config, puppet::agent::service

  anchor { 'puppet::agent::begin': } ->
    Class['puppet::agent::install'] ->
    Class['puppet::agent::config'] ~>
    Class['puppet::agent::service'] ->
    anchor { 'puppet::agent::end': }
}
