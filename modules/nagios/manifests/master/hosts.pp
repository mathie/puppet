class nagios::master::hosts {
  nagios::master::resource {
    [ 'hostgroup', 'host' ]:
      ensure => present;
  }

  nagios_hostgroup {
    'all':
      alias   => 'All Servers',
      members => '*';

    'precise':
      alias   => 'Ubuntu 12.04 LTS servers';
  }

  nagios_host {
    'ubuntu-precise-host':
      register       => 0,
      use            => 'generic-host',
      notes          => 'Ubuntu 12.04 LTS servers',
      icon_image     => 'base/ubuntu.png',
      icon_image_alt => 'Ubuntu 12.04 LTS servers',
      vrml_image     => 'ubuntu.png',
      statusmap_image => 'base/ubuntu.gd2';

    'generic-host':
      register                     => 0,
      notifications_enabled        => 1,
      event_handler_enabled        => 1,
      flap_detection_enabled       => 1,
      failure_prediction_enabled   => 1,
      process_perf_data            => 1,
      retain_status_information    => 1,
      retain_nonstatus_information => 1,
      check_command                => 'check-host-alive',
      max_check_attempts           => 10,
      notification_interval        => 0,
      notification_period          => '24x7',
      notification_options         => 'd,u,r',
      contact_groups               => 'admins';
  }

  Nagios_host <<| |>> {
    use    => 'ubuntu-precise-host',
    notify => Class['nagios::master::service']
  }

  Nagios_hostgroup <<| |>> {
    notify => Class['nagios::master::service']
  }
}
