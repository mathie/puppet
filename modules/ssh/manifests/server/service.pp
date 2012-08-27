class ssh::server::service {
  service {
    'ssh':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true;
  }
}
