class apt::cache::server($clients = undef) {
  include apt::cache::server::firewall,
    apt::cache::server::install,
    apt::cache::server::config,
    apt::cache::server::service

  anchor { 'apt::cache::server::begin': } ->
    Class['apt::cache::server::firewall'] ->
    Class['apt::cache::server::install'] ->
    Class['apt::cache::server::config'] ~>
    Class['apt::cache::server::service'] ->
    anchor { 'apt::cache::server::end': }
}
