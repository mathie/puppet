define apache::site($apache_vhost_name, $username = $name, $source = undef, $content = undef, $require = undef) {
  include apache

  if $source or $content {
    file {
      "/etc/apache2/sites-available/${name}":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => $source,
        content => $content,
        require => $require,
        notify  => Class['apache::service'];
    }
  } else {
    file {
      "/etc/apache2/sites-available/${name}":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('apache/site.erb'),
        require => $require,
        notify  => Class['apache::service'];
    }
  }

  $a2ensite_require = $require ? {
    undef   => File["/etc/apache2/sites-available/${name}"],
    default => [ $require, File["/etc/apache2/sites-available/${name}"] ],
  }

  exec {
    "a2ensite-${name}":
      command => "/usr/sbin/a2ensite ${name}",
      creates => "/etc/apache2/sites-enabled/${name}",
      require => $a2ensite_require,
      notify  => Class['apache::service'];
  }
}
