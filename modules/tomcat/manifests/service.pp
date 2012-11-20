class tomcat::service {
  service {
    'tomcat6':
      ensure => running,
      enable => true;
  }
}
