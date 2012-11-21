class eatmydata {
  package {
    'eatmydata':
      ensure => present;
  }

  exec {
    'divert-dpkg':
      command => '/usr/bin/dpkg-divert --rename /usr/bin/dpkg',
      creates => '/usr/bin/dpkg.distrib',
      require => Package['eatmydata'];
  }

  file {
    '/usr/bin/dpkg':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0755',
      content => "#!/bin/sh\nexec /usr/bin/eatmydata /usr/bin/dpkg.distrib \"\$@\"\n",
      require => [ Exec['divert-dpkg'], Package['eatmydata'] ];
  }
}
