class stages {
  stage {
    'first':
      before => Stage['main'];

    'last':
      require => Stage['main'];
  }
}
