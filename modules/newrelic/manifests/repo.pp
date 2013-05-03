class newrelic::repo($stage = first) {
  apt::repository {
    'newrelic':
      url          => 'http://apt.newrelic.com/debian/',
      distribution => 'newrelic',
      components   => [ 'non-free' ],
      keyid        => '548C16BF';
  }
}
