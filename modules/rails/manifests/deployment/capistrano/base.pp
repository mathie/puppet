class rails::deployment::capistrano::base {
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
