class collectd::plugins::master {
  file {
    '/var/lib/collectd/rrd':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';
  }

  collectd::plugin {
    [ 'rrdtool' ]:
      ensure => present,
      config => 'DataDir "/var/lib/collectd/rrd"';

    'network-master':
      ensure => present,
      plugin => 'network',
      config => template('collectd/plugins/network-master.conf.erb');
  }

  @@collectd::plugin {
    'network-client':
      ensure => present,
      plugin => 'network',
      config => template('collectd/plugins/network-agent.conf.erb');
  }
}
