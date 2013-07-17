class fail2ban::config {
  $email     = $fail2ban::email
  $whitelist = $fail2ban::whitelist

  concat::file {
    'fail2ban-jail.local':
      path  => '/etc/fail2ban/jail.local',
      owner => root,
      group => root,
      mode  => '0644',
      head  => template('fail2ban/jail-default.conf.erb');
  }

  file {
    '/etc/fail2ban/action.d/sendmail-whois-lines.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('fail2ban/sendmail-whois-lines.conf.erb');
  }
}
