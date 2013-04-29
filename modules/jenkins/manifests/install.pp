class jenkins::install {
  include jenkins::repo

  package {
    'default-jre-headless':
      ensure => present;

    'default-jdk':
      ensure => present;

    'jenkins':
      ensure => present;

    'jenkins-cli':
      ensure => present;
  }

  Class['jenkins::repo'] -> Class['jenkins::install']
}
