class ssh::client::config {
  file {
    '/etc/ssh/ssh_known_hosts':
      ensure => present,
      source => 'puppet:///modules/ssh/ssh_known_hosts',
      owner  => root,
      group  => root,
      mode   => '0644';
  }
}
