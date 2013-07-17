define fail2ban::action(
  $content,
  $ensure = present
) {
  include fail2ban

  file {
    "/etc/fail2ban/action.d/${name}.conf":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $content;
  }
}
