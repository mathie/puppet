class rails::unicorn::install($ruby_version = '1.9') {
  if $ruby_version == '1.8' {
    include ruby::ruby18
    $gem_provider    = 'gem18'
    $ruby_dependency = Class['ruby::ruby18']
  } else {
    include ruby::ruby19
    $gem_provider    = 'gem19'
    $ruby_dependency = Class['ruby::ruby19']
  }

  package {
    'unicorn':
      ensure   => present,
      provider => $gem_provider,
      require  => $ruby_dependency;
  }
}
