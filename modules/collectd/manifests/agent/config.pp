class collectd::agent::config {
  include collectd::config
  include collectd::plugins::agent

  Class['collectd::config'] -> Class['collectd::plugins::agent'] ~> Class['collectd::service']

  # It's a bit odd, but this causes a symlink to be generated on the server
  # from the collectd-collected RRDs for each agent to where Graphite expects
  # the RRDs to be stored. It's nicer than the previous hack I was doing. :)
  $graphite_friendly_filename = regsubst($::fqdn, '\.', '_', 'G')
  @@file {
    "/opt/graphite/storage/rrd/collectd/${$graphite_friendly_filename}":
      ensure => link,
      target => "/var/lib/collectd/rrd/${$::fqdn}",
      tag    => 'collectd-host-rrds';
  }

}
