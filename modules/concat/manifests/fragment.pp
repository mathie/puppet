define concat::fragment(
  $file,
  $order   = 50,
  $content = undef,
  $source  = undef
) {
  file {
    "${concat::fragment_root}/${file}/${order}_${name}":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0600',
      content => $content,
      source  => $source,
      before  => Exec["concat-${file}"];
  }
}
