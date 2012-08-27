class puppet::config {
  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    content => template('puppet/puppet.conf.erb'),
    owner   => puppet,
    group   => puppet,
    mode    => '0644',
  }
}
