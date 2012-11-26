class hubot {
  include nodejs::npm, redis::server
  include hubot::install, hubot::config, hubot::service

  Class['redis::server'] -> Class['hubot::install']
  Class['nodejs'] -> Class['hubot::install']
  Class['hubot::install'] -> Class['hubot::config'] ~> Class['hubot::service']
}
