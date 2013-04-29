class puppetdb::client::config {
  $puppetdb_server_hostname = $puppetdb::client::puppetdb_server_hostname

  file {
    '/etc/puppet/puppetdb.conf':
      ensure  => present,
      owner   => puppet,
      group   => puppet,
      mode    => '0644',
      content => template('puppetdb/puppetdb.conf.erb');

    '/etc/puppet/routes.yaml':
      ensure  => present,
      owner   => puppet,
      group   => puppet,
      mode    => '0644',
      content => template('puppetdb/routes.yaml.erb');
  }

  concat::fragment {
    'puppet-conf-puppetdb':
      file    => 'puppet.conf',
      content => template('puppetdb/puppet-puppetdb.conf.erb');
  }
}
