class newrelic::agent::install {
  include newrelic::repo

  package {
    'newrelic-sysmond':
      ensure => present,
  }
}
