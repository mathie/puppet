class crtmpserver::service {
  service {
    'crtmpserver':
      ensure => running,
      enable => true;
  }

  firewall::allow {
    'rtmp-tcp':
      port => 1935;

    'rtmp-udp':
      port  => 1935,
      proto => 'udp';
  }
}
