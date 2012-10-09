class rails::unicorn::service($app_name) {
  service {
    "${app_name}-unicorn":
      ensure => running,
      enable => true;
  }
}
