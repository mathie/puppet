class localisation($locale = 'en_GB', $timezone = 'GB-Eire') {
  $full_locale     = "${locale}.UTF-8"
  $localedef_locale = "${locale}.utf8"

  exec {
    'generate-locale':
      command => "/usr/sbin/locale-gen --purge ${full_locale}",
      unless  => "/usr/bin/localedef --list-archive | /bin/grep ${localedef_locale}";
  }

  file {
    '/etc/default/locale':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => "LANG='${full_locale}'\n",
      require => Exec['generate-locale'];
  }

  file {
    '/etc/timezone':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => "${timezone}\n";

    '/etc/localtime':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => "file:///usr/share/zoneinfo/${timezone}";
  }
}
