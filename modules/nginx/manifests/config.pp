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

    '/etc/nginx/conf.d/limits.conf':
      ensure => present,
      source => 'puppet:///modules/nginx/limits.conf';

    '/etc/nginx/conf.d/proxy.conf':
      ensure => present,
      source => 'puppet:///modules/nginx/proxy.conf';
  }

  concat::file {
    'nginx-htpasswd':
      ensure => present,
      path   => '/etc/nginx/htpasswd',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  Concat::Fragment <| file == 'nginx-htpasswd' |>
}
