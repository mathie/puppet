class apache::php_fcgid {
  include php::cgi
  include apache::fcgid

  apache::module {
    'actions':
  }

  file {
    '/etc/apache2/conf.d/php_fcgid':
      ensure => present,
      source => 'puppet:///modules/apache/php_fcgid.conf',
      owner  => root,
      group  => root,
      mode   => '0644',
      notify => Class['apache::service'];

    '/var/www/fcgi-bin':
      ensure => directory,
      owner  => www-data,
      group  => www-data,
      mode   => '0755';

    '/var/www/fcgi-bin/php-fcgid':
      ensure => present,
      source => 'puppet:///modules/apache/php-fcgid',
      owner  => www-data,
      group  => www-data,
      mode   => '0755';
  }
}
