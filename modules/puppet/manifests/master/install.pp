class puppet::master::install {
  include ruby::ruby18

  package {
    'puppetmaster':
      ensure => installed;
  }
}
