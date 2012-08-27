class rails::deployment::capistrano::base {
  include ruby::ruby19

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

  package {
    'bundler':
      ensure   => present,
      provider => 'gem19',
      require  => Class['ruby::ruby19'];
  }
}
