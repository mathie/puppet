class puppetdb::server::service {
  service {
    'puppetdb':
      ensure => running,
      enable => true;
  }
}
