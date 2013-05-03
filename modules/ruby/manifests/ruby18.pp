class ruby::ruby18 {
  include ruby::ruby18::install

  anchor { 'ruby::ruby18::begin': } ->
    Class['ruby::ruby18::install'] ->
    anchor { 'ruby::ruby18::end': }
}
