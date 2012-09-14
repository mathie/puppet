define nginx::vhost($ensure = 'present', $content) {
  include nginx

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
      ensure  => $ensure ? {
        'present' => 'link',
        default   => 'absent',
      },
      owner   => root,
      group   => root,
      mode    => '0644',
      target  => "/etc/nginx/sites-available/${name}.conf",
      require => File["/etc/nginx/sites-available/${name}.conf"],
      notify  => Class['nginx::service'];
  }
}
