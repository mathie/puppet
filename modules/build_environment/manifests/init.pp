class build_environment {
  package {
    'build-essential':
      ensure => present;
  }
}
