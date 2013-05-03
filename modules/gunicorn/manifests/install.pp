class gunicorn::install {
  include gunicorn::repo

  package {
    'gunicorn':
      ensure => present;
  }
}
