node /^ci\./ {
  include standard
  include ci::master
}

node 'temperature' {
  include standard
  include temperature
}

node 'puppet' {
  include standard
  include puppetmaster, puppet::dashboard
  include mcollective::middleware, mcollective::client
  include openvpn::server
  include rsyslog::server
  include graphite
}
