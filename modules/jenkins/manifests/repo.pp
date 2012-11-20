class jenkins::repo {
  include apt

  apt::repository {
    'jenkins':
      source => 'puppet:///modules/jenkins/sources.list';
  }

  apt::key {
    'jenkins-public-key':
      keyid => 'D50582E6';
  }
}
