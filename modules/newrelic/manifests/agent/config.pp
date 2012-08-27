class newrelic::agent::config($license_key) {
  file {
    '/etc/newrelic/nrsysmond.cfg':
      ensure  => present,
      content => template('newrelic/nrsysmond.cfg.erb'),
      owner   => root,
      group   => newrelic,
      mode    => '0640';
  }
}
