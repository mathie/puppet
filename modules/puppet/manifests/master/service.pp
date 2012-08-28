class puppet::master::service {
  service { 'puppetmaster':
    ensure => running,
    enable => true;
  }

  # Don't configure the firewall while bootstrapping, as we haven't
  # enabled ssh (and the ssh firewall rule!) yet.
  if !$::bootstrapping {
    firewall::allow {
      'puppetmaster':
        port => 8140;
    }
  }
}
