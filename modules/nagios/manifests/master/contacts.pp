class nagios::master::contacts {
  $nagios_admins = $::nagios::master::admins

  nagios::master::resource {
    [ 'contactgroup', 'contact' ]:
  }

  nagios_contactgroup {
    'admins':
      ensure  => present,
      members => $nagios_admins;
  }

  Nagios_contact <| |> {
    service_notification_commands => 'notify-service-by-email',
    service_notification_period   => '24x7',
    host_notification_commands    => 'notify-host-by-email',
    host_notification_period      => '24x7',
    require                       => File['/etc/nagios'],
    notify                        => Class['nagios::master::service']
  }

  Nagios_contact <<| |>> {
    service_notification_commands => 'notify-service-by-email',
    service_notification_period   => '24x7',
    host_notification_commands    => 'notify-host-by-email',
    host_notification_period      => '24x7',
    require                       => File['/etc/nagios'],
    notify                        => Class['nagios::master::service']
  }
}
