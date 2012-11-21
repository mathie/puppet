class ci::master {
  include jenkins
  include nginx

  include ci::config
  include ci::dependencies
  include ci::plugins

  nginx::vhost {
    'ci':
      content => template('ci/nginx.conf.erb');
  }

  Class['jenkins'] -> Class['ci::config']
}
