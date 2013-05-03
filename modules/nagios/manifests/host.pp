define nagios::host($ensure = present) {
  @@nagios_host {
    $::fqdn:
      ensure     => $ensure,
      alias      => $::hostname,
      hostgroups => [ $::lsbdistcodename ],
      address    => $::ipaddress_preferred;
  }
}
