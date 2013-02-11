class java {
  include java::install

  anchor { 'java::begin': } ->
    Class['java::install'] ->
    anchor { 'java::end': }
}
