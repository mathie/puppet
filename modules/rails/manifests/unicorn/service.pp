class rails::unicorn::service($app_name) {
  service {
    # FIXME: This doesn't strictly belong here, should be part of the generic
    # code deployment, I think.
    $app_name:
      ensure => running,
      enable => true;

    "${app_name}-unicorn":
      ensure => running,
      enable => true;
  }
}
