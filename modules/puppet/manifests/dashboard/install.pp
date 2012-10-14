class puppet::dashboard::install {
  include ruby::ruby18

  package {
    'daemons':
      ensure   => '1.0.10',
      provider => 'gem18';

    'rack':
      ensure   => '1.1.2',
      provider => 'gem18';

    'mongrel':
      ensure   => present,
      provider => 'gem18';

    'rdoc':
      ensure   => present,
      provider => 'gem18';

    'puppet-dashboard':
      ensure => present;
  }
}
