class firewall::config {
  file {
    '/etc/default/ufw':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/firewall/etc-default-ufw';
  }

  if($firewall::enabled) {
    exec {
      'firewall-default-deny':
        command => '/usr/sbin/ufw default deny',
        unless  => '/usr/sbin/ufw status verbose | /bin/grep \'^Default: deny\'';

      'firewall-enable':
        command => '/usr/bin/yes | /usr/sbin/ufw enable',
        unless  => '/usr/sbin/ufw status | /bin/grep "^Status: active"';
    }

    Exec['firewall-default-deny'] -> Exec['firewall-enable']

    Firewall::Allow <| |>
  } else {
    exec {
      'firewall-disable':
        command => '/usr/sbin/ufw disable',
        unless  => '/usr/sbin/ufw status | /bin/grep "^Status: inactive"';
    }
  }
}
