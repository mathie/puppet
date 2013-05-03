class mysql::dev {
  include mysql::repo

  package {
    'libmysqlclient-dev':
      ensure => present;
  }

}
