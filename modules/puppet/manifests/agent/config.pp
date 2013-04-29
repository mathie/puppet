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

  concat::fragment {
    'puppet-conf-agent':
      file    => 'puppet.conf',
      content => template('puppet/puppet-agent.conf.erb');
  }

  anchor { 'puppet::agent::config::begin': } ->
    Class['puppet::config'] ->
    anchor { 'puppet::agent::config::end': }
}
