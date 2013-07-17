# There are plenty more options to override; these were all the ones I needed
# for now.
define fail2ban::jail(
  $ensure    = present,
  $port      = undef,
  $maxretry  = undef,
  $banaction = undef,
  $filter    = undef,
  $logpath   = undef,
  $findtime  = undef,
  $bantime  = undef
) {
  include fail2ban

  $jail_name = $name

  $enabled = $ensure ? {
    present => 'true',
    default => 'false',
  }

  concat::fragment {
    "fail2ban-jail-${name}":
      file    => 'fail2ban-jail.local',
      content => template('fail2ban/jail.conf.erb');
  }
}
