class postfix::install {
  package {
    'postfix':
      ensure => present;

    'mailutils':
      ensure => present;
  }
}
