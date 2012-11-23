class rails::resque::service($app_name) {
  service {
    "${app_name}-resque":
      ensure => running,
      enable => true;
  }
}
