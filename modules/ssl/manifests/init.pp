class ssl {
  include ssl::install, ssl::config

  Class['ssl::install'] -> Class['ssl::config']
}
