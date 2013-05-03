class collectd::config {
  include collectd::plugins::standard

  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/etc/collectd':
      ensure => directory;

    '/etc/collectd/conf.d':
      ensure => directory;

    '/etc/collectd/collectd.conf':
      ensure  => present,
      content => template('collectd/collectd.conf.erb');
  }

  anchor { 'collectd::config::begin': } ->
    Class['collectd::plugins::standard'] ->
    anchor { 'collectd::config::end': }
}
