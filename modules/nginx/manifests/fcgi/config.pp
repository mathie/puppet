class nginx::fcgi::config {
  file {
    '/etc/nginx/fastcgi_params':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/nginx/fastcgi_params';
  }

  nginx::upstream { 'fcgiwrap': }

  nginx::upstream::server {
    "fcgiwrap_socket_${::hostname}":
      upstream => 'fcgiwrap',
      target   => 'unix:/var/run/fcgiwrap.socket';
  }
}
