class ruby::install {
  package {
    [ 'ruby', 'ruby-switch' ]:
      ensure => present;
  }

  exec {
    # Mcollective and puppet require Ruby 1.8 so make sure the system default
    # is 1.8. This is only an issue if Puppet somehow decides to install ruby
    # 1.9 first, but it will prevent mcollective from starting (probably a bug
    # with mcollective, really).
    'ruby-switch-1.8':
      command => '/usr/bin/ruby-switch --set ruby1.8',
      unless  => '/usr/bin/ruby-switch --check | /bin/grep "^Currently using: ruby1.8"',
      require => Package['ruby-switch']
  }
}
