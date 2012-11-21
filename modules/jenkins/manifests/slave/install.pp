class jenkins::slave::install {
  package {
    'jenkins-slave':
      ensure => present;

    'wget':
      ensure => present;
  }
}
