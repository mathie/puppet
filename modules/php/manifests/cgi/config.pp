class php::cgi::config {
  file {
    '/etc/php5/cgi/php.ini':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/php/cgi/php.ini';
  }
}
