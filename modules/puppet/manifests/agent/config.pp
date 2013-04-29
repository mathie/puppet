class puppet::agent::config {
  include puppet::config

  file { '/etc/default/puppet':
    ensure => present,
    source => 'puppet:///modules/puppet/etc-default-puppet',
    owner  => puppet,
    group  => puppet,
    mode   => '0644',
  }

  anchor { 'puppet::agent::config::begin': } ->
    Class['puppet::config'] ->
    anchor { 'puppet::agent::config::end': }
}
