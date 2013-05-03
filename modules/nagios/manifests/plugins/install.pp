class nagios::plugins::install {
  include mysql::repo

  package {
    'nagios-plugins-extra':
      ensure => present;

    'percona-nagios-plugins':
      ensure => present;
  }
}
