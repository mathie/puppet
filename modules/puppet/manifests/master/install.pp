class puppet::master::install {
  include ruby::ruby18

  package {
    'puppetmaster':
      ensure => installed;
  }

  Class['puppet::repo'] -> Package['puppetmaster']
}
