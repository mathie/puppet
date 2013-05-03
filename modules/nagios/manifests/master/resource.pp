define nagios::master::resource($ensure = present) {
  $resource_name = $name

  $link_ensure = $ensure ? {
    present => link,
    default => absent,
  }

  file {
    "/etc/nagios/nagios_${resource_name}.cfg":
      owner   => root,
      group   => root,
      mode    => '0644';

    "/etc/nagios3/conf.d/${resource_name}s_nagios2.cfg":
      ensure => $link_ensure,
      target => "/etc/nagios/nagios_${resource_name}.cfg";
  }

  resources {
    "nagios_${resource_name}":
      before => File["/etc/nagios/nagios_${resource_name}.cfg"],
      purge  => true;
  }
}
