define tomcat::user($password, $roles) {
  concat::fragment {
    "tomcat-user-${name}":
      file    => 'tomcat-users',
      content => "<user username=\"${name}\" password=\"${password}\" roles=\"${roles}\"/>\n";
  }
}
