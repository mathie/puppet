class tomcat::install {
  package {
    'tomcat6':
      ensure => present;

    'libtcnative-1':
      ensure => present;
  }
}
