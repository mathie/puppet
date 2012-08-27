class mcollective::agent::install {
  package {
    [ 'ruby-stomp', 'mcollective', 'mcollective-plugins-process', 'mcollective-plugins-facts-facter', 'mcollective-plugins-package', 'mcollective-plugins-service' ]:
      ensure => present,
  }

  Package['ruby-stomp'] -> Package['mcollective']

  # Package installation seems to fail if we install plugins before the
  # mcollective package itself, despite the package dependencies being
  # correct...
  Package['mcollective'] -> Package['mcollective-plugins-process']
  Package['mcollective'] -> Package['mcollective-plugins-facts-facter']
  Package['mcollective'] -> Package['mcollective-plugins-package']
  Package['mcollective'] -> Package['mcollective-plugins-service']
}
