class ntp::server::service {
  service {
    'ntp':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true;
  }
}
