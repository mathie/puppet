class apache::fcgid {
  include apache

  package {
    'libapache2-mod-fcgid':
      ensure => installed;
  }

  apache::module {
    'fcgid':
      require => Package['libapache2-mod-fcgid'],
      content => template('apache/fcgid.conf.erb');
  }
}
