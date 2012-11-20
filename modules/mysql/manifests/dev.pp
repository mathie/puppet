class mysql::dev {
  include mysql::repo

  package {
    'libmysqlclient-dev':
      ensure => present;
  }

  Class['mysql::repo'] -> Exec['apt-get-update'] -> Class['mysql::dev']
}
