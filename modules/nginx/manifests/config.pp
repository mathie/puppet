class nginx::config {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/etc/nginx':
      ensure => directory;

    '/etc/nginx/conf.d':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/nginx/sites-available':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/nginx/sites-enabled':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/nginx/upstreams.d':
      ensure  => directory,
      recurse => true,
      force   => true,
      purge   => true;

    '/etc/nginx/mime.types':
      ensure => present,
      source => 'puppet:///modules/nginx/mime.types';

    '/etc/nginx/nginx.conf':
      ensure => present,
      source => 'puppet:///modules/nginx/nginx.conf';

    '/etc/nginx/conf.d/ssl.conf':
      ensure => present,
      source => 'puppet:///modules/nginx/ssl.conf';

    '/etc/nginx/conf.d/gzip.conf':
      ensure => present,
      source => 'puppet:///modules/nginx/gzip.conf';
  }
}
