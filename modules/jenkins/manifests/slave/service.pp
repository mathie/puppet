class jenkins::slave::service {
  service {
    'jenkins-slave':
      ensure => stopped,
      enable => false;
  }
}
