class mcollective::agent {
  include mcollective::agent::install, mcollective::agent::config, mcollective::agent::service
  Class['mcollective::agent::install'] -> Class['mcollective::agent::config'] ~> Class['mcollective::agent::service']
}
