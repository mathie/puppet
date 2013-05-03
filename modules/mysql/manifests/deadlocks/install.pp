class mysql::deadlocks::install {
  include mysql::repo

  package {
    'percona-toolkit':
      ensure => present;
  }
}
