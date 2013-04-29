class mysql::server::backup(
  $aws_access_key,
  $aws_access_key_secret,
  $aws_bucket = 'mysql-backup'
) {
  include mysql::server::backup::install, mysql::server::backup::config

  anchor { 'mysql::server::backup::begin': } ->
    Class['mysql::server::backup::install'] ->
    Class['mysql::server::backup::config'] ->
    anchor { 'mysql::server::backup::end': }
}
