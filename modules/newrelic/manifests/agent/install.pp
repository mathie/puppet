class newrelic::agent::install {
  apt::repository {
    'newrelic':
      url          => 'http://apt.newrelic.com/debian/',
      distribution => 'newrelic',
      components   => [ 'non-free' ],
      keyid        => '548C16BF';
  }

  package {
    'newrelic-sysmond':
      ensure => present,
  }

  Apt::Repository['newrelic'] -> Package['newrelic-sysmond']
}
