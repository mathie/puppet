class jenkins::repo($stage = first) {
  apt::repository {
    'jenkins':
      url          => 'http://pkg.jenkins-ci.org/debian',
      keyid        => 'D50582E6',
      distribution => 'binary',
      components   => [ ];
  }
}
