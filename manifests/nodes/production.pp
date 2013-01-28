node /^ci\./ {
  include rubaidh
  include ci::master
}

node /^ci-slave[0-9]+\./ {
  include rubaidh
  include ci::slave
}

node /^git\./ {
  include rubaidh
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

# If you're freshly bootstrapping and errors node, you'll want to seed the
# database. I've been too lazy to figure out how to automate it with MongoDB,
# so you'll need to do:
#
#   ruby1.9.1 -S bundle exec rake errbit:bootstrap RAILS_ENV=production
#
# as the errbit user in /u/apps/errbit/current.
node /^errors\./ {
  include rubaidh
  include mongodb::server
  include errbit

  Class['mongodb::server'] -> Class['errbit']
}

node /^hubot\./ {
  include rubaidh
  include hubot
}

node 'temperature' {
  include rubaidh
  include temperature
}

node 'puppet' {
  include rubaidh
  include puppetmaster, puppet::dashboard
  include mcollective::middleware, mcollective::client
  include openvpn::server
  include rsyslog::server
  include graphite
}
