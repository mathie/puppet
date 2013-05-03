class nagios::nrpe_check::puppet(
  $warning  = 3600, # seconds - 1 hour
  $critical = 7200  # seconds - 2 hours
) {
  file {
    '/usr/lib/nagios/plugins/check_puppet_agent':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0755',
      source  => 'puppet:///modules/nagios/check_puppet_agent',
      require => Class['nagios::plugins'];
  }

  nagios::nrpe_check {
    'puppet_agent':
      service_description => 'Puppet Agent',
      groups              => [ 'host' ],
      warning             => $warning,
      critical            => $critical;
  }
}
