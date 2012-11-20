class ci::master {
  include jenkins::tomcat
  include nginx

  nginx::vhost {
    'ci':
      content => template('ci/nginx.conf.erb');
  }
}
