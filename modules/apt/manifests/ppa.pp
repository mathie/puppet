define apt::ppa($user, $repo = 'ppa', $distribution = 'precise') {
  include apt

  exec {
    "add-apt-repository-${name}":
      command => "/usr/bin/add-apt-repository ppa:${user}/${repo}",
      creates => "/etc/apt/sources.list.d/${user}-${repo}-${distribution}.list",
      notify  => Exec['apt-get-update'],
      require => Package['python-software-properties'];
  }
}
