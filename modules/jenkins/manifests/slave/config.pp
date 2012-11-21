class jenkins::slave::config($master) {
  file {
    '/etc/default/jenkins-slave':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('jenkins/etc-default-jenkins-slave.erb');
  }
}
