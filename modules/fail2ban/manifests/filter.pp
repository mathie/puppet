define fail2ban::filter(
  $content,
  $ensure = present
) {
  include fail2ban

  file {
    "/etc/fail2ban/filter.d/${name}.conf":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $content;
  }
}
