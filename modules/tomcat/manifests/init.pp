class tomcat {
  include tomcat::install, tomcat::config, tomcat::service

  Class['tomcat::install'] -> Class['tomcat::config'] ~> Class['tomcat::service']
}
