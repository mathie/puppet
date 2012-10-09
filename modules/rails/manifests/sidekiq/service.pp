class rails::sidekiq::service($app_name) {
  service {
    "${app_name}-sidekiq":
      ensure => running,
      enable => true;
  }
}
