class sudo::service {
  exec {
    'expire-sudo-privileges':
      command     => "/etc/init.d/sudo start",
      refreshonly => true;
  }
}
