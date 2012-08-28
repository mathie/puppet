class rails::deployment::capistrano::base::common {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/u':
      ensure => directory;

    '/u/apps':
      ensure => directory;
  }
}

class rails::deployment::capistrano::base($ruby_version) {
  include rails::deployment::capistrano::base::common

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
    'bundler':
      ensure   => present,
      provider => $gem_provider,
      require  => $ruby_dependency;
  }
}
