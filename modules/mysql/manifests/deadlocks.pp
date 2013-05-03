class mysql::deadlocks($database = 'percona', $password = 'wee1quie1Vohf1d') {
  include mysql::deadlocks::install, mysql::deadlocks::config, mysql::deadlocks::service

  anchor { 'mysql::deadlocks::begin': } ->
    Class['mysql::deadlocks::install'] ->
    Class['mysql::deadlocks::config'] ~>
    Class['mysql::deadlocks::service'] ->
    anchor { 'mysql::deadlocks::end': }
}
