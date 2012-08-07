class newrelic::agent($license_key) {
  include newrelic::agent::install, newrelic::agent::service

  class {
    'newrelic::agent::config':
      license_key => $license_key;
  }

  Class['newrelic::agent::install'] -> Class['newrelic::agent::config'] ~> Class['newrelic::agent::service']
}
