class jenkins::tomcat {
  include ::tomcat

  include jenkins::tomcat::install, jenkins::tomcat::config

  Class['jenkins::tomcat::install'] -> Class['jenkins::tomcat::config'] ~> Class['tomcat::service']
}
