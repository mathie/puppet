define network::host_alias() {
  @@host {
    "${name}.${::domain}":
      ensure       => present,
      ip           => $::ipaddress_internal,
      host_aliases => [ $name ];
  }
}
