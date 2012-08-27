class ssh::client::config {
  @@sshkey {
    $::hostname:
      host_aliases => [ $::fqdn, $::ipaddress_preferred ],
      type         => 'ecdsa-sha2-nistp256',
      key          => $::sshecdsakey;
  }

  Sshkey <<| |>>
}
