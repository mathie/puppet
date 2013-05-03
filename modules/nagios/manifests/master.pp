class nagios::master($admins = [ 'mathie' ]) {
  include nginx::fcgi, nginx::php
  include nagios::plugins
  include nagios::master::install, nagios::master::config, nagios::master::service

  anchor { 'nagios::master::begin': } ->
    Class['nagios::plugins'] ->
    Class['nagios::master::install'] ->
    Class['nagios::master::config'] ~>
    Class['nagios::master::service'] ->
    anchor { 'nagios::master::end': }
}
