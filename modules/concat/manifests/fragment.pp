define concat::fragment(
  $file,
  $order   = 50,
  $content = undef,
  $source  = undef,
  $ensure  = present
) {
  $sanitised_file = regsubst($file, '[/ ]', '_', 'G')
  $sanitised_name = regsubst($name, '[/ ]', '_', 'G')

  file {
    "${concat::fragment_root}/${sanitised_file}/${order}_${sanitised_name}":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0600',
      content => $content,
      source  => $source,
      before  => Exec["concat-${file}"];
  }
}
