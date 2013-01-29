class php::cgi {
  include php::cgi::install, php::cgi::config

  Class['php::cgi::install'] -> Class['php::cgi::config']
}
