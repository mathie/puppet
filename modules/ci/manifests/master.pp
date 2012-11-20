class ci::master {
  include jenkins
  include nginx

  nginx::vhost {
    'ci':
      content => template('ci/nginx.conf.erb');
  }
}
