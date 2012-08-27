class mcollective::client {
  include mcollective::client::install, mcollective::client::config
  Class['mcollective::client::install'] -> Class['mcollective::client::config']
}
