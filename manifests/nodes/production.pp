node /^ci\./ {
  include standard
  include ci::master
}

node /^ci-slave[0-9]+\./ {
  include standard

  class {
    'ci::slave':
      master => "ci.${::domain}";
  }
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
