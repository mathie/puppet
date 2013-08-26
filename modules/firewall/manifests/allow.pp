define firewall::allow(
  $port,
  $proto   = 'tcp',
  $sources = undef,
  $ensure  = present
) {
  $proto_string = "proto ${proto}"

  if $ensure == present {
    if $sources {
      $sources.each { |$ip_address|
        exec {
          "firewall-allow-${name}-${proto}-${port}-${ip_address}":
            command => "/usr/sbin/ufw allow ${proto_string} from ${ip_address} to any port ${port}",
            unless  => "/usr/sbin/ufw status verbose | /bin/grep '^${port}/${proto}.*ALLOW IN.*${ip_address}'",
            require => Class['firewall'];
        }
      }
    } else {
      exec {
        "firewall-allow-${name}-${proto}-${port}":
          command => "/usr/sbin/ufw allow ${proto_string} from any to any port ${port}",
          unless  => "/usr/sbin/ufw status verbose | /bin/grep '^${port}/${proto}.*ALLOW IN.*Anywhere'",
          require => Class['firewall'];
      }
    }
  } else {
    if $sources {
      $sources.each { |$ip_address|
        exec {
          "firewall-allow-${name}-${proto}-${port}-${ip_address}":
            command => "/usr/sbin/ufw delete ${proto_string} from ${ip_address} to any port ${port}",
            onlyif  => "/usr/sbin/ufw status verbose | /bin/grep '^${port}/${proto}.*ALLOW IN.*${ip_address}'",
            require => Class['firewall'];
        }
      }
    } else {
      exec {
        "firewall-allow-${name}-${proto}-${port}":
          command => "/usr/sbin/ufw delete ${proto_string} from any to any port ${port}",
          onlyif  => "/usr/sbin/ufw status verbose | /bin/grep '^${port}/${proto}.*ALLOW IN.*Anywhere'",
          require => Class['firewall'];
      }
    }
  }
}
