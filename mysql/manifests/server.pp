class mysql::server {
  include mysql::server::install, mysql::server::config, mysql::server::service

  # This is slightly unusual in terms of dependencies. The package helpfully
  # configures MySQL, creates the data store and starts the service for us. If
  # it was to do so before we provided our own my.cnf configuration, it would
  # create the DB backing store with the defaults. We don't want the defaults,
  # and when we supply a different my.cnf, it then fails to start the service
  # (because the on disk storage doesn't match the configuration). The solution
  # is to make sure the configuration is in place before the package is
  # installed. This is fine with my.cnf because it's not supplied by the
  # package. Might cause problems with other configuration files in future,
  # though.
  Class['mysql::server::config'] -> Class['mysql::server::install']
  Class['mysql::server::install'] -> Class['mysql::server::service']
  Class['mysql::server::config'] ~> Class['mysql::server::service']
}
