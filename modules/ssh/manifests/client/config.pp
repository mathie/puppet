class ssh::client::config {
  file {
    '/etc/ssh/ssh_known_hosts':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  @@sshkey {
    $::hostname:
      host_aliases => [ $::fqdn, $::ipaddress_preferred ],
      type         => 'ecdsa-sha2-nistp256',
      key          => $::sshecdsakey;
  }

  Sshkey <<| |>>
}
