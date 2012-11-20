class tomcat::config {
  concat::file {
    'tomcat-users':
      path  => '/etc/tomcat6/tomcat-users.xml',
      owner => root,
      group => tomcat6,
      mode  => '0640',
      head  => template('tomcat/tomcat-users-head.xml'),
      tail  => template('tomcat/tomcat-users-tail.xml');
  }

  tomcat::role {
    'admin':
  }

  tomcat::user {
    'mathie':
      password => 'Tung6eim',
      roles    => 'admin';
  }
}
