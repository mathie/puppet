class ruby::repo {
  include apt

  apt::repository {
    'brightbox-ruby-ng-experimental-precise':
      source => 'puppet:///modules/ruby/sources.list';
  }

  apt::key {
    'brightbox-ruby-ng-experimental-precise':
      keyid => 'C3173AA6';
  }
}
