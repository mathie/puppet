class phantomjs {
  include xvfb

  package {
    'phantomjs':
      ensure => present;
  }
}
