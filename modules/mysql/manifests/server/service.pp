class mysql::server::service {
  service {
    'mysql':
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      enable     => true;
  }
}
