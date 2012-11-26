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
  include mysql::server
  include redis::server

  mysql::server::database {
    'gitlab':
      user     => 'gitlab',
      password => 'Useebae9';
  }

  class {
    'gitlab':
      database    => 'gitlab',
      db_username => 'gitlab',
      db_password => 'Useebae9';
  }
}

node /^hubot\./ {
  include standard
  include hubot
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
