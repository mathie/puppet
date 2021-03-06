class nagios::agent(
  $htpasswd_user     = 'nagios',
  $htpasswd_password = 'Gahqua4f'
) {
  include nagios::plugins
  include nagios::agent::install, nagios::agent::config, nagios::agent::service

  anchor { 'nagios::agent::begin': } ->
    Class['nagios::plugins'] ->
    Class['nagios::agent::install'] ->
    Class['nagios::agent::config'] ~>
    Class['nagios::agent::service'] ->
    anchor { 'nagios::agent::end': }
}
