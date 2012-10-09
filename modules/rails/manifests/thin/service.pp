class rails::thin::service($app_name) {
  service {
    "${app_name}-thin":
      ensure  => running,
      enable  => true,
      require => File["/etc/init/${app_name}-thin.conf"];
  }
}
