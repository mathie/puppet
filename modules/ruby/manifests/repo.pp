class ruby::repo($stage = first) {
  apt::repository {
    'brightbox-ruby-ng-experimental-precise':
      url   => 'http://ppa.launchpad.net/brightbox/ruby-ng-experimental/ubuntu',
      keyid => 'C3173AA6';
  }
}
