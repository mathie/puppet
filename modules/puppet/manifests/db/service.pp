class puppet::db::service {
  service { 'puppetdb':
    ensure => running,
    enable => true;
  }
}
