class sasl::saslauthd {
  include sasl::saslauthd::install, sasl::saslauthd::config, sasl::saslauthd::service

  Class['sasl::saslauthd::install'] -> Class['sasl::saslauthd::config'] ~> Class['sasl::saslauthd::service']
}
