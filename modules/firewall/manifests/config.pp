class firewall::config {
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
  } else {
    exec {
      'firewall-disable':
        command => '/usr/sbin/ufw disable',
        unless  => '/usr/sbin/ufw status | /bin/grep "^Status: inactive"';
    }
  }
}
