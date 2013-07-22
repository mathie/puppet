class ruby::ruby18 {
  include ruby::ruby18::install, ruby::ruby18::dev

  anchor { 'ruby::ruby18::begin': } ->
    Class['ruby::ruby18::install'] ->
    Class['ruby::ruby18::dev'] ->
    anchor { 'ruby::ruby18::end': }
}
