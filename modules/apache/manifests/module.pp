define apache::module($source = undef, $content = undef) {
  include apache

  if $source or $content {
    file {
      "/etc/apache2/mods-available/${name}.conf":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => $source,
        content => $content,
        notify  => Class['apache::service'];
    }
  }

  exec {
    "a2enmod-${name}":
      command => "/usr/sbin/a2enmod ${name}",
      creates => "/etc/apache2/mods-enabled/${name}.load",
      notify  => Class['apache::service'];
  }
}
