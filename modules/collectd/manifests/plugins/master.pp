class collectd::plugins::master {
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

  firewall::allow {
    'collectd-udp':
      port  => 25826,
      proto => 'udp';
  }
}