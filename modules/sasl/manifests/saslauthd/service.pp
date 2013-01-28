class sasl::saslauthd::service {
  service {
    'saslauthd':
      ensure => running,
      enable => true;
  }
}
