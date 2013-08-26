class graphite {
  include memcached::server, gunicorn
  include graphite::install, graphite::config, graphite::service

  Class['gunicorn'] -> Class['graphite']

  anchor { 'graphite::begin': } ->
    Class['graphite::install'] ->
    Class['graphite::config'] ~>
    Class['graphite::service'] ->
    anchor { 'graphite::end': }
}
