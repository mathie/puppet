class collectd::master::config {
  include collectd::config
  include collectd::plugins::master

  file {
    '/etc/collectd/users':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0600',
      source => 'puppet:///modules/collectd/users';
  }

  anchor { 'collectd::master::config::begin': } ->
    Class['collectd::config'] ->
    Class['collectd::plugins::master'] ->
    anchor { 'collectd::master::config::end': }
}
