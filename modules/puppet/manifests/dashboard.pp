class puppet::dashboard {
  include puppet::dashboard::install, puppet::dashboard::config, puppet::dashboard::service

  anchor { 'puppet::dashboard::begin': } ->
    Class['puppet::dashboard::install'] ->
    Class['puppet::dashboard::config'] ~>
    Class['puppet::dashboard::service'] ->
    anchor { 'puppet::dashboard::end': }
}
