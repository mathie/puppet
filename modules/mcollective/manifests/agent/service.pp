class mcollective::agent::service {
  service {
    'mcollective':
      ensure => running,
      enable => true;
  }
}
