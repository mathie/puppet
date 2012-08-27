class rails::unicorn::install {
  include ruby::ruby19

  package {
    "unicorn":
      ensure   => present,
      provider => 'gem19',
      require  => Class['ruby::ruby19'];
  }
}
