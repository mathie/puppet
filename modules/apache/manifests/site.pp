define apache::site($apache_vhost_name = "${name}.com", $default = false, $ensure = present, $username = $name, $source = undef, $content = undef) {
  include apache

  $site_filename = $default ? {
    true    => 'default',
    default => $name,
  }

  $enabled_site_filename = $default ? {
    true    => '000-default',
    default => $site_filename,
  }

  if $source or $content {
    file {
      "/etc/apache2/sites-available/${site_filename}":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => $source,
        content => $content,
        notify  => Class['apache::service'];
    }
  } else {
    file {
      "/etc/apache2/sites-available/${site_filename}":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template('apache/site.erb'),
        notify  => Class['apache::service'];
    }
  }

  case $ensure {
    present: {
      exec {
        "a2ensite-${name}":
          command => "/usr/sbin/a2ensite ${site_filename}",
          creates => "/etc/apache2/sites-enabled/${enabled_site_filename}",
          require => File["/etc/apache2/sites-available/${site_filename}"],
          notify  => Class['apache::service'];
      }
    }

    default: {
      exec {
        "a2dissite-${name}":
          command => "/usr/sbin/a2dissite ${site_filename}",
          onlyif  => "/usr/bin/test -f /etc/apache2/sites-enabled/${enabled_site_filename}",
          notify  => Class['apache::service'];
      }
    }
  }
}
