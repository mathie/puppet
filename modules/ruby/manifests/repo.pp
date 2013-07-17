class ruby::repo($stage = first) {
  apt::repository {
    'brightbox-ruby-ng-experimental-precise':
      url   => 'http://ppa.launchpad.net/brightbox/ruby-ng-experimental/ubuntu',
      keyid => 'C3173AA6';
  }

  file {
    '/etc/apt/preferences.d/pin-ruby':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/ruby/apt-preferences-pin-ruby';
  }
}
