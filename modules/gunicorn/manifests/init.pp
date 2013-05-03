class gunicorn {
  include gunicorn::install

  anchor { 'gunicorn::begin': } ->
    Class['gunicorn::install'] ->
    anchor { 'gunicorn::end': }
}
