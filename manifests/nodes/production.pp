node /^ci\./ {
  include standard
  include ci::master
}

node /^ci-slave[0-9]+\./ {
  include standard
  include ci::slave
}

node /^git\./ {
  include standard
  include gitolite
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
