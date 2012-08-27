class opendkim::service {
  service {
    'opendkim':
      ensure     => running,
      hasstatus  => false,
      enable     => true;
  }
}
