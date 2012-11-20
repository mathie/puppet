define tomcat::role {
  concat::fragment {
    "tomcat-role-${name}":
      file    => 'tomcat-users',
      content => "<role rolename=\"${name}\"/>\n";
  }
}
