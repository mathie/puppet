class puppet::master($ssh_key, $git_repo) {
  include puppet::agent
  include puppet::master::install, puppet::master::service

  class {
    'puppet::master::config':
      ssh_key  => $ssh_key,
      git_repo => $git_repo;
  }

  Class['puppet::master::install'] -> Class['puppet::master::config'] ~> Class['puppet::master::service']
}
