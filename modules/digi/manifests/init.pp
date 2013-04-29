class digi(
  $username,
  $password,
  $cache_file    = '/u/apps/digi/current/tmp/cache.dump',
  $display_files = '/u/apps/digi/current/tmp/display_files'
) {
  include digi::install, digi::config

  anchor { 'digi::begin': } ->
    Class['digi::install'] ->
    Class['digi::config'] ->
    anchor { 'digi::end': }
}
