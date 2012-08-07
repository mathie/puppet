class ruby::ruby19 {
  include ruby::repo, ruby::ruby19::install

  Class['ruby::repo'] -> Exec['apt-get-update'] -> Class['ruby::ruby19::install']
}
