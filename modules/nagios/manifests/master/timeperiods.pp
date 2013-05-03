class nagios::master::timeperiods {
  nagios::master::resource {
    'timeperiod':
  }

  nagios_timeperiod {
    '24x7':
      alias     => '24 Hours A Day, 7 Days A Week',
      monday    => '00:00-24:00',
      tuesday   => '00:00-24:00',
      wednesday => '00:00-24:00',
      thursday  => '00:00-24:00',
      friday    => '00:00-24:00',
      saturday  => '00:00-24:00',
      sunday    => '00:00-24:00';

    'never':
      alias => 'Never';

    'workinghours':
      alias     => 'Standard office hours',
      monday    => '09:00-17:00',
      tuesday   => '09:00-17:00',
      wednesday => '09:00-17:00',
      thursday  => '09:00-17:00',
      friday    => '09:00-17:00';

    'nonworkhours':
      alias     => 'Outside standard office hours',
      monday    => '00:00-09:00,17:00-24:00',
      tuesday   => '00:00-09:00,17:00-24:00',
      wednesday => '00:00-09:00,17:00-24:00',
      thursday  => '00:00-09:00,17:00-24:00',
      friday    => '00:00-09:00,17:00-24:00',
      saturday  => '00:00-24:00',
      sunday    => '00:00-24:00';
  }

  Nagios_timeperiod <<| |>> {
    notify => Class['nagios::master::service']
  }
}
