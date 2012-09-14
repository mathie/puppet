define ssl::certificate($certificate, $private_key, $intermediate_cert_bundle = undef) {
  include ssl

  file {
    "/etc/ssl/certs/${name}.pem":
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $certificate;

    "/etc/ssl/private/${name}.key":
      owner   => root,
      group   => root,
      mode    => '0600',
      content => $private_key;
  }

  Class['ssl'] -> File["/etc/ssl/certs/${name}.pem"] -> File["/etc/ssl/private/${name}.key"]

  if($intermediate_cert_bundle) {
    concat::file {
      "ssl-certificate-${name}-bundle":
        path  => "/etc/ssl/certs/${name}-bundle.pem",
        owner => root,
        group => root,
        mode  => '0644',
        head  => $certificate,
        tail  => $intermediate_cert_bundle;
    }

    Class['ssl'] -> Concat::File["ssl-certificate-${name}-bundle"]
  }
}
