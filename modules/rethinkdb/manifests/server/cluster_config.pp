class rethinkdb::server::cluster_config {
  exec {
    "rethink-create-datacenter-${::datacenter}":
      command => "/usr/bin/rethinkdb admin -j localhost:29015 create datacenter ${::datacenter}",
      unless  => "/usr/bin/rethinkdb admin -j localhost:29015 ls datacenters | /bin/grep ${::datacenter} 2>&1 > /dev/null";

    "rethink-add-host-${::hostname}-to-datacenter-${::datacenter}":
      command => "/usr/bin/rethinkdb admin -j localhost:29015 set datacenter ${::hostname} ${::datacenter}",
      unless  => "/usr/bin/rethinkdb admin -j localhost:29015 ls machines --long | /bin/grep ${::hostname} | /bin/grep $(/usr/bin/rethinkdb admin -j localhost:29015 ls datacenters --long| /usr/bin/awk '/${::datacenter}/ { print \$1 }')";
  }
}
