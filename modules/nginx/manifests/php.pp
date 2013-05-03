class nginx::php {
  include nginx::php::install, nginx::php::config, nginx::php::service

  anchor { 'nginx::php::begin': } ->
    Class['nginx::php::install'] ->
    Class['nginx::php::config'] ~>
    Class['nginx::php::service'] ->
    anchor { 'nginx::php::end': }
}
