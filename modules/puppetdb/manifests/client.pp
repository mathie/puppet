class puppetdb::client(
  $puppetdb_server_host_name = $puppet::agent::puppetmaster_host_name
) {
  include puppetdb::client::install, puppetdb::client::config

  anchor { 'puppetdb::client::begin': } ->
    Class['puppetdb::client::install'] ->
    Class['puppetdb::client::config'] ->
    anchor { 'puppetdb::client::end': }
}
