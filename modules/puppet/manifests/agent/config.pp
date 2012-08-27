class puppet::agent::config {
  include puppet::config

  file { '/etc/default/puppet':
    ensure => present,
    source => 'puppet:///modules/puppet/etc-default-puppet',
    owner  => puppet,
    group  => puppet,
    mode   => '0644',
  }

  if $::bootstrapping {
    Class['puppet::config'] -> Class['puppet::agent::service']
  } else {
    Class['puppet::config'] ~> Class['puppet::agent::service']
  }
}
