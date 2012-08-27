class puppet::agent {
  include puppet::agent::install, puppet::agent::config, puppet::agent::service

  # If we're bootstrapping, the the puppet agent service will get started
  # anyway, and it seems to get started, then immediately restarted if the
  # notification is in place. Argh.
  if $::bootstrapping {
    Class['puppet::agent::install'] -> Class['puppet::agent::config'] -> Class['puppet::agent::service']
  } else {
    Class['puppet::agent::install'] -> Class['puppet::agent::config'] ~> Class['puppet::agent::service']
  }
}
