node 'puppet' {
  include standard
  include puppetmaster
  include mcollective::middleware, mcollective::client
  include openvpn::server
  include rsyslog::server
  include graphite
}
