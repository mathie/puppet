class nagios::plugins {
  include nagios::plugins::install, nagios::plugins::config

  anchor { 'nagios::plugins::begin': } ->
    Class['nagios::plugins::install'] ->
    Class['nagios::plugins::config'] ->
    anchor { 'nagios::plugins::end': }
}
