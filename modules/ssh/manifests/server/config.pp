class ssh::server::config {
  $port = $ssh::server::real_port

  file {
    '/etc/ssh/sshd_config':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('ssh/sshd_config.erb');
  }

  fail2ban::jail {
    'ssh':
      port     => $port,
      bantime => 604800,
      maxretry => 3;
  }
}
