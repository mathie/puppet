class ruby::bundler18 {
  package {
    'bundler':
      ensure   => present,
      provider => 'gem18',
      require  => Class['ruby::ruby18'];
  }
}
