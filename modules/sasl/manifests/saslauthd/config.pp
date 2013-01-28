class sasl::saslauthd::config {
  file {
    '/etc/default/saslauthd':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sasl/etc-default-saslauthd';
  }
}
