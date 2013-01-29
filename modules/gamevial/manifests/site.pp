define gamevial::site($apache_vhost_name, $uid) {
  users::account {
    $name:
      uid                 => $uid,
      ssh_authorized_keys => 'puppet:///modules/gamevial/authorized_keys',
      comment             => "${name} web site";
  }

  file {
    "/home/${name}/public_html":
      ensure  => directory,
      owner   => $name,
      group   => $name,
      mode    => '0755',
      require => Users::Account[$name];
  }

  apache::site {
    $name:
      apache_vhost_name => $apache_vhost_name;
  }
}
