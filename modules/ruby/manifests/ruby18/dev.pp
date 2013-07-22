class ruby::ruby18::dev {
  include build_environment
  include ruby::repo

  package {
    'ruby1.8-dev':
      ensure => present;
  }
}
