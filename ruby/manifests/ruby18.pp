class ruby::ruby18 {
  include ruby::repo, ruby::ruby18::install

  Class['ruby::repo'] -> Exec['apt-get-update'] -> Class['ruby::ruby18::install']
}
