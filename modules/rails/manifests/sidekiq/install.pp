class rails::sidekiq::install {
  include ruby::ruby19

  package {
    "sidekiq":
      ensure   => present,
      provider => 'gem19',
      require  => Class['ruby::ruby19'];
  }
}
