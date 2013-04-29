class network::hosts {
  resources { 'host': purge => true }

  host {
    'localhost':
      ensure       => present,
      ip           => '127.0.0.1';

    'ip6-localhost':
      ensure       => present,
      ip           => '::1',
      host_aliases => 'ip6-loopback';

    'ip6-localnet':
      ensure => present,
      ip     => 'fe00::0';

    'ip6-mcastprefix':
      ensure => present,
      ip     => 'ff00::0';

    'ip6-allnodes':
      ensure => present,
      ip     => 'ff02::1';

    'ip6-allrouters':
      ensure => present,
      ip     => 'ff02::2';

    'ip6-allhosts':
      ensure => present,
      ip     => 'ff02::3';
  }

  if $::vagrant == 'true' {
    host {
      "gate.${::domain}":
        ensure => present,
        ip     => $::gateway;
    }
  }

  @@host {
    $::fqdn:
      ensure       => present,
      ip           => $::ipaddress_preferred,
      host_aliases => [ $::hostname ];
  }

  Host <<| title != $::fqdn |>>

  # Even if the exported resource for Host[$fqdn] is not realised on this host
  # the name of the resource still exists, so we have to think of
  # a new name for this one. All this to get the bootstrapped behaviour
  # of 127.0.1.1 to be what's resolved by the local hostname so that
  # it still works with puppetdb (which binds to the hostname's interface
  # by default).
  host {
    $::hostname:
      ensure       => present,
      ip           => '127.0.1.1',
      host_aliases => [ $::fqdn ];
  }

  package {
    'resolvconf':
      ensure => absent;
  }

  file {
    '/etc/resolv.conf':
      ensure   => present,
      owner    => root,
      group    => root,
      mode     => '0644',
      content  => template('network/resolv.conf.erb'),
      require  => Package['resolvconf'];
  }
}
