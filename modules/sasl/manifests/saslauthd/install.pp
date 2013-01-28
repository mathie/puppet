class sasl::saslauthd::install {
  package {
    'sasl2-bin':
      ensure => present;
  }
}
