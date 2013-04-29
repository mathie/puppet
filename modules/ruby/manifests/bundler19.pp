class ruby::bundler19 {
  package {
    'bundler19':
      ensure   => present,
      provider => 'gem19',
      require  => Class['ruby::ruby19'];
  }
}
