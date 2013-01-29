define gamevial::site($apache_vhost_name, $uid, $default = false) {
  $username = $name

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

    "/home/${name}/fcgi-bin":
      ensure => directory,
      owner  => $name,
      group  => $name,
      mode   => '0755';

    "/home/${name}/fcgi-bin/php-fcgid":
      ensure => present,
      source => 'puppet:///modules/apache/php-fcgid',
      owner  => $name,
      group  => $name,
      mode   => '0755';
  }

  apache::site {
    $name:
      apache_vhost_name => $apache_vhost_name,
      default           => $default;
  }
}
