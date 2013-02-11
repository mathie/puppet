class java::install {
  package {
    'openjdk-7-jre-headless':
      ensure => present;
  }
}
