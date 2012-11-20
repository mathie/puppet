class imagemagick::dev {
  package {
    'libmagickwand-dev':
      ensure => present;
  }
}
