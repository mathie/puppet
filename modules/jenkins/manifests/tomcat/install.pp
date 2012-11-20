class jenkins::tomcat::install {
  package {
    'jenkins-tomcat':
      ensure => present;
  }
}
