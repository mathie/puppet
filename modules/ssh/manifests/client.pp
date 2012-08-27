class ssh::client {
  include ssh::client::install, ssh::client::config

  Class['ssh::client::install'] -> Class['ssh::client::config']
}
