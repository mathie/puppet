class jenkins::install {
  package {
    'jenkins-tomcat':
      ensure => present;
  }
}
