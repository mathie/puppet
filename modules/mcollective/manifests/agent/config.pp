class mcollective::agent::config {
  file {
    '/etc/mcollective/server.cfg':
      ensure  => present,
      content => template('mcollective/server.cfg.erb'),
      owner   => root,
      group   => root,
      mode    => '0600';

    # According to:
    #
    #  https://bugs.launchpad.net/ubuntu/+source/mcollective-plugins/+bug/1061287
    #
    # the reason that mcollective's service and package plugins haven't been
    # working so far as becuase they're misnamed. Yay, I've been missing having
    # access to mco service.
    '/usr/share/mcollective/plugins/mcollective/agent/service.rb':
      ensure => link,
      target => '/usr/share/mcollective/plugins/mcollective/agent/puppet-service.rb',
      owner  => root,
      group  => root,
      mode   => '0644';

    '/usr/share/mcollective/plugins/mcollective/agent/package.rb':
      ensure => link,
      target => '/usr/share/mcollective/plugins/mcollective/agent/puppet-package.rb',
      owner  => root,
      group  => root,
      mode   => '0644';
  }
}
