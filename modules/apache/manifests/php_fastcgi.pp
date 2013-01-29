class apache::php_fastcgi {
  include php::cgi

  apache::module {
    'actions':
  }

  class {
    'apache::fastcgi':
  }

  file {
    '/etc/apache2/conf.d/php_fastcgi':
      ensure => present,
      source => 'puppet:///modules/apache/php_fastcgi.conf',
      owner  => root,
      group  => root,
      mode   => '0644',
      notify => Class['apache::service'];

    '/var/www/fcgi-bin':
      ensure => directory,
      owner  => www-data,
      group  => www-data,
      mode   => '0755';

    '/var/www/fcgi-bin/php-fastcgi':
      ensure => present,
      source => 'puppet:///modules/apache/php-fastcgi',
      owner  => www-data,
      group  => www-data,
      mode   => '0755';
  }
}
