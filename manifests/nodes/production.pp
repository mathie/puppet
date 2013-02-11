node /^ci\./ {
  include standard::rubaidh
  include ci::master
}

node /^ci-slave[0-9]+\./ {
  include standard::rubaidh
  include ci::slave
}

node /^git\./ {
  include standard::rubaidh
  include mysql::server
  include redis::server

  rails::database {
    'gitlab':
      db_type  => 'mysql2',
      password => 'Useebae9';
  }

  include gitlab
}

# If you're freshly bootstrapping and errors node, you'll want to seed the
# database. I've been too lazy to figure out how to automate it with MongoDB,
# so you'll need to do:
#
#   ruby1.9.1 -S bundle exec rake errbit:bootstrap RAILS_ENV=production
#
# as the errbit user in /u/apps/errbit/current.
node /^errors\./ {
  include standard::rubaidh
  include mongodb::server
  include errbit

  Class['mongodb::server'] -> Class['errbit']
}

node /^hubot\./ {
  include standard::rubaidh
  include hubot
}

node 'temperature' {
  include standard::rubaidh
  include temperature
}

node 'puppet' {
  include standard::rubaidh
  include puppetmaster, puppet::dashboard
  include mcollective::middleware, mcollective::client
  include openvpn::server
  include rsyslog::server
  include graphite
}
