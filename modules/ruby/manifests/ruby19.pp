class ruby::ruby19 {
  include ruby::ruby19::install, ruby::ruby19::dev

  anchor { 'ruby::ruby19::begin': } ->
    Class['ruby::ruby19::install'] ->
    Class['ruby::ruby19::dev'] ->
    anchor { 'ruby::ruby19::end': }
}
