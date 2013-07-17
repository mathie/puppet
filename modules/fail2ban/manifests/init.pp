class fail2ban(
  $email     = [
    "root@${::domain}"
  ],
  $whitelist = []
) {
  include fail2ban::install, fail2ban::config, fail2ban::service

  anchor { 'fail2ban::begin': } ->
    Class['fail2ban::install'] ->
    Class['fail2ban::config'] ~>
    Class['fail2ban::service'] ->
    anchor { 'fail2ban::end': }
}
