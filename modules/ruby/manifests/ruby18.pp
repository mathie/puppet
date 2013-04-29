class ruby::ruby18 {
  include ruby::repo, ruby::ruby18::install

  Class['ruby::repo'] -> Class['ruby::ruby18::install']
}
