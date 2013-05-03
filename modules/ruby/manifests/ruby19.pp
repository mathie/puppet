class ruby::ruby19 {
  include ruby::ruby19::install

  anchor { 'ruby::ruby19::begin': } ->
    Class['ruby::ruby19::install'] ->
    anchor { 'ruby::ruby19::end': }
}
