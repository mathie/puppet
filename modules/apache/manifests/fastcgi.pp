class apache::fastcgi($suexec = false) {
  include apache

  package {
    'libapache2-mod-fastcgi':
      ensure => installed;
  }

  apache::module {
    'fastcgi':
      require => Package['libapache2-mod-fastcgi'],
      content => template('apache/fastcgi.conf.erb');
  }
}
