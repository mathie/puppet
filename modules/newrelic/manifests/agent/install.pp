class newrelic::agent::install {
  include apt

  apt::repository {
    'newrelic':
      source => 'puppet:///modules/newrelic/sources.list';
  }

  apt::key {
    'newrelic-public-key':
      keyid => '548C16BF';
  }

  package {
    'newrelic-sysmond':
      ensure => present,
  }

  Apt::Repository['newrelic'] -> Exec['apt-get-update'] -> Package['newrelic-sysmond']
  Apt::Key['newrelic-public-key'] -> Package['newrelic-sysmond']
}
