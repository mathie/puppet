define fail2ban::jail::nginx(
  $port     = [ 'http', 'https' ],
  $logpath  = '/var/log/nginx/access.log',
  $maxretry = 50,
  $bantime  = 604800,
  $findtime = 60
) {
  $filter = $name

  fail2ban::jail {
    "nginx-${filter}":
      ensure   => present,
      port     => inline_template('<%= @port.join(',') %>'),
      filter   => $filter,
      logpath  => $logpath,
      maxretry => $maxretry,
      bantime  => $bantime,
      findtime => $findtime;
  }
}
