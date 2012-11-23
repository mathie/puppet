class gitolite {
  include git, ssh::server

  include gitolite::install, gitolite::config

  Class['git'] -> Class['ssh::server'] -> Class['gitolite::install'] -> Class['gitolite::config']
}
