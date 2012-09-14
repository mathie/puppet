define firewall::allow($port, $proto = 'tcp') {
  if($firewall::enabled) {
    exec {
      "firewall-allow-${proto}-${port}":
        command => "/usr/sbin/ufw allow proto ${proto} from any to any port ${port}",
        unless  => "/usr/sbin/ufw status verbose | /bin/grep '^${port}/${proto}.*ALLOW IN'",
        require => Class['firewall'];
    }
  }
}
