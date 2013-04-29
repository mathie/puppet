class puppetdb::client(
  $puppetdb_server_hostname = $puppet::agent::puppetmaster_hostname
) {
  include puppetdb::client::install, puppetdb::client::config

  anchor { 'puppetdb::client::begin': } ->
    Class['puppetdb::client::install'] ->
    Class['puppetdb::client::config'] ->
    anchor { 'puppetdb::client::end': }
}
