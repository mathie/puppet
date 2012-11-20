class ruby::bundler19 {
  package {
    'bundler':
      ensure   => present,
      provider => 'gem19',
      require  => Class['ruby::ruby19'];
  }
}
