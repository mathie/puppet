class ssl::config {
  # It would appear that there are two versions of this particular certificate
  # kicking around, and SagePay happens to use the one that isn't supplied by
  # the system. I have no idea what this is all about, and I've probably just
  # compromised the world. See:
  #
  #   http://serverfault.com/questions/373920/ubuntu-11-10-using-wget-curl-fails-with-ssl
  #
  # for some more details.
  file {
    '/usr/share/ca-certificates/mozilla/Verisign_Class_3_Public_Primary_Certification_Authority.crt':
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/ssl/Verisign_Class_3_Public_Primary_Certification_Authority.crt',
      notify => Exec['update-ca-certificates'];
  }

  exec {
    'update-ca-certificates':
      command     => '/usr/sbin/update-ca-certificates',
      refreshonly => true;
  }
}
