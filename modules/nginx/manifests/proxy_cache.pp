class nginx::proxy_cache {
  $nginx_var_path         = '/var/lib/nginx'
  $nginx_proxy_cache_path = "${nginx_var_path}/proxy_cache"
  $nginx_proxy_temp_path  = "${nginx_var_path}/proxy_temp"

  file {
    $nginx_var_path:
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';

    $nginx_proxy_cache_path:
      ensure => directory,
      owner  => www-data,
      group  => www-data,
      mode   => '0700';

    $nginx_proxy_temp_path:
      ensure => directory,
      owner  => www-data,
      group  => www-data,
      mode   => '0700';

    '/etc/nginx/conf.d/proxy_cache.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('nginx/nginx-proxy-cache.conf.erb'),
      require => [ File[$nginx_proxy_cache_path], File[$nginx_proxy_temp_path] ];
  }

  Class['nginx::proxy_cache'] ~> Class['nginx::service']
}
