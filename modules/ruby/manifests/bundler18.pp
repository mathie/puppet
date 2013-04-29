class ruby::bundler18 {
  package {
    'bundler18':
      ensure   => present,
      provider => 'gem18',
      require  => Class['ruby::ruby18'];
  }
}
