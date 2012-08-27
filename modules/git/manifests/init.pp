class git {
  include git::install, git::config

  Class['git::install'] -> Class['git::config']
}
