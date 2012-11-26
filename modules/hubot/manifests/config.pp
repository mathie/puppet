class hubot::config {
  file {
    '/etc/init/hubot.conf':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/hubot/hubot.conf';
  }
}
