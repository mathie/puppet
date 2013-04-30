class postfix::install {
  package {
    'postfix':
      ensure => present;

    # For a command line mail client. mailutils would seem like a sensible
    # option, but it depends on libmysql, which gets a little hairy when we're
    # trying to get percona client installed instead...
    'bsd-mailx':
      ensure => present;
  }
}
