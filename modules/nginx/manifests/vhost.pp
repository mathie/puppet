define nginx::vhost($content, $ensure = 'present') {
  include nginx

  $enabled = $ensure ? {
    'present' => 'link',
    default   => 'absent',
  }

  file {
    "/etc/nginx/sites-available/${name}.conf":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $content,
      require => Class['nginx'],
      notify  => Class['nginx::service'];

    "/etc/nginx/sites-enabled/${name}.conf":
      ensure  => $enabled,
      owner   => root,
      group   => root,
      mode    => '0644',
      target  => "/etc/nginx/sites-available/${name}.conf",
      require => File["/etc/nginx/sites-available/${name}.conf"],
      notify  => Class['nginx::service'];
  }
}
