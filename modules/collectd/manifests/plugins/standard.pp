class collectd::plugins::standard {
  collectd::plugin {
    [ 'syslog', 'cpu', 'df', 'disk', 'entropy', 'interface', 'irq', 'load', 'memory', 'processes', 'swap', 'users' ]:
      ensure => present;
  }
}
