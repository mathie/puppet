class ruby::ruby19::dev {
  include build_environment
  include ruby::repo

  package {
    'ruby1.9.1-dev':
      ensure => present;
  }
}
