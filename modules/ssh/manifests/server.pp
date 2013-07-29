class ssh::server($port = 22) {
  # Force SSH to be on port 22 in Vagrant because vagrant depends upon that
  # being the case.
  $real_port = str2bool($::vagrant) ? {
    true    => 22,
    default => $port,
  }

  include ssh::server::install, ssh::server::config, ssh::server::service

  Class['ssh::server::install'] -> Class['ssh::server::config'] ~> Class['ssh::server::service']
}
