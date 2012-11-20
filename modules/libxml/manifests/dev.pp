class libxml::dev {
  package {
    'libxml2-dev':
      ensure => present;

    'libxslt1-dev':
      ensure => present;
  }
}
