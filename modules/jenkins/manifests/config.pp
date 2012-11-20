class jenkins::config {
  file {
    '/etc/jenkins/cli.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('jenkins/cli.conf.erb');
  }
}
