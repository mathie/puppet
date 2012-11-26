class nodejs::npm {
  include nodejs

  package {
    'npm':
      ensure => present;
  }
}
