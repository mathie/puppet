class mysql::server::service {
  service {
    'mysql':
      ensure => running,
      enable => true;
  }

  if $mysql::server::root_password {
    exec {
      'mysql-set-root-password':
        command => "/usr/bin/mysqladmin -uroot password ${mysql::server::root_password}",
        unless  => "/usr/bin/mysql -uroot -p${mysql::server::root_password} mysql -e 'SELECT 1=1'",
        require => Service['mysql'];
    }
  }

  firewall::allow {
    'mysql':
      port => '3306';
  }
}
