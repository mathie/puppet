class ssh::server::service {
  service {
    'ssh':
      ensure => running,
      enable => true;
  }
}
