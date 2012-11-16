node 'puppet' {
  include standard
  include puppetmaster, puppet::dashboard
  include mcollective::middleware, mcollective::client
  include rsyslog::server
  include graphite
}
