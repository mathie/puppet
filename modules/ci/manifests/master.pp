class ci::master {
  include jenkins
  include nginx

  include ci::config
  include ci::dependencies
  include ci::plugins

  nginx::vhost_to_local_upstream {
    'ci':
      upstream_port           => 8080,
      root                    => '/var/lib/jenkins/www',
      vagrant_additional_port => 8090;
  }

  Class['jenkins'] -> Class['ci::config']
}
