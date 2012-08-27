class nginx::config {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/etc/nginx/sites-available/default':
      ensure => absent;

    '/etc/nginx/sites-enabled/default':
      ensure => absent;
  }
}
