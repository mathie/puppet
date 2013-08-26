class puppet::agent::config {
  $puppetmaster_hostname = $puppet::agent::puppetmaster_hostname

  include puppet::config

  file { '/etc/default/puppet':
    ensure  => present,
    content => "START=yes\n",
    owner   => puppet,
    group   => puppet,
    mode    => '0644',
  }

  concat::file {
    'agent.conf':
      ensure  => present,
      path    => '/etc/puppet/conf.d/agent.conf',
      head    => "[agent]\n",
      owner   => root,
      group   => root,
      mode    => '0644',
      require => File['/etc/puppet/conf.d'],
      before  => Exec['generate-puppet-conf'];
  }

  concat::fragment {
    'puppet-conf-agent':
      file    => 'agent.conf',
      content => template('puppet/puppet-agent.conf.erb');
  }

  anchor { 'puppet::agent::config::begin': } ->
    Class['puppet::config'] ->
    anchor { 'puppet::agent::config::end': }
}
