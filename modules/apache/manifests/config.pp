class apache::config {
  file {
    '/etc/apache2/conf.d/prefork':
      ensure => present,
      source => 'puppet:///modules/apache/prefork.conf',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

}
