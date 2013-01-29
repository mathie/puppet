class apache::suexec {
  include apache

  package {
    'apache2-suexec':
      ensure => installed;
  }

  apache::module {
    'suexec':
      require => Package['apache2-suexec'];
  }
}
