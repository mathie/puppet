class ruby::ruby19 {
  include ruby::repo, ruby::ruby19::install

  Class['ruby::repo'] -> Class['ruby::ruby19::install']
}
