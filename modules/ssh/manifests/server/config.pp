class ssh::server::config {
  file {
    '/etc/ssh/sshd_config':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/ssh/sshd_config';
  }
}
