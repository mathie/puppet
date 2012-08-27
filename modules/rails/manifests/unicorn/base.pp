class rails::unicorn::base {
  File {
    owner => root,
    group => root,
    mode  => '0644',
  }

  file {
    '/etc/unicorn':
      ensure => directory;
  }
}
