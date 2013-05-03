class nginx::fcgi {
  include nginx::fcgi::install, nginx::fcgi::config, nginx::fcgi::service

  anchor { 'nginx::fcgi::begin': } ->
    Class['nginx::fcgi::install'] ->
    Class['nginx::fcgi::config'] ~>
    Class['nginx::fcgi::service'] ->
    anchor { 'nginx::fcgi::end': }
}
