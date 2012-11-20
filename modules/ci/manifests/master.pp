class ci::master {
  include jenkins
  include nginx
  include ci::dependencies

  nginx::vhost {
    'ci':
      content => template('ci/nginx.conf.erb');
  }
}
