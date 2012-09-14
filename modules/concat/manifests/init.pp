class concat {
  $fragment_root = '/var/lib/puppet/concat_fragments'

  file {
    $fragment_root:
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0700',
      recurse => true,
      purge   => true,
      force   => true;
  }
}
