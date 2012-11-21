class jenkins::slave::service {
  service {
    'jenkins-slave':
      ensure => running,
      enable => true;
  }
}
