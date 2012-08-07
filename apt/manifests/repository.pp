define apt::repository($source) {
  file {
    "/etc/apt/sources.list.d/${title}.list":
      source => $source,
      owner  => root,
      group  => root,
      mode   => '0644',
      notify => Exec['apt-get-update'];
  }
}
