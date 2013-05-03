class mysql::dev {
  include mysql::repo
  include ssl::dev

  package {
    'libmysqlclient-dev':
      ensure => present;
  }

  anchor { 'mysql::dev::begin': } ->
    Class['ssl::dev'] ->
    anchor { 'mysql::dev::end': }
}
