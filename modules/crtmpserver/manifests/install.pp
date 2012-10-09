class crtmpserver::install {
  package {
    'crtmpserver':
      ensure => present;
  }
}
